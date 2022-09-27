import 'package:jomar_barcode/models/site_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class InventaireDatabase {
  Future<void> initialiseDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = "$databasesPath/inventaire.db";
    // await deleteDatabase(path);
    var database = await openDatabase(path,
        version: 2,
        onConfigure: (db) async {}, onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Inventaires (id TEXT PRIMARY KEY, no TEXT, service TEXT, bureau TEXT, barcode TEXT, date TEXT)');

      await db.execute(
          'CREATE TABLE IF NOT EXISTS Services (id TEXT PRIMARY KEY, name TEXT, localisation TEXT)');

      await db.execute(
          'CREATE TABLE IF NOT EXISTS IventaireConfig (id TEXT PRIMARY KEY, no TEXT, isActive INTEGER)');
      // await db.execute(
      //     'CREATE TABLE IF NOT EXISTS Bureaux (id TEXT PRIMARY KEY, name TEXT)');
      // await db.execute(
      //     'CREATE TABLE IF NOT EXISTS BureauxScans (BureauId TEXT, ScanId TEXT)');
      // await db.execute(
      //     'CREATE TABLE IF NOT EXISTS Scans (id TEXT PRIMARY KEY, value TEXT)');
    });
    var uuid = const Uuid();

    List<Map> services = await database.rawQuery('SELECT * FROM Services');

    if (services.isEmpty) {
      InventaireDatabase.defaultServices.forEach((service) async {
        database.insert(
          'Services',
          {
            'id': uuid.v1(),
            'name': service.name,
            'localisation': service.localisation
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    }
  }

  Future<List<Map>> getServices() async {
    var databasesPath = await getDatabasesPath();
    // String path = join(databasesPath, 'demo.db');
    String path = "$databasesPath/inventaire.db";
    var database = await openDatabase(path, version: 2);
    List<Map> services = await database.rawQuery('SELECT * FROM Services');
    return services;
  }

  Future addService(Service service) async {
    var databasesPath = await getDatabasesPath();
    var uuid = const Uuid();
    String path = "$databasesPath/inventaire.db";
    var database = await openDatabase(path, version: 2);
    database.insert(
      'Services',
      {
        'id': uuid.v1(),
        'name': service.name,
        'localisation': service.localisation
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future addInventaire(Inventaire inventaire) async {
    var databasesPath = await getDatabasesPath();
    var uuid = const Uuid();
    String path = "$databasesPath/inventaire.db";
    var database = await openDatabase(path, version: 2);

    await database.insert(
      'Inventaires',
      {
        'id': uuid.v1(),
        'no': inventaire.no,
        'service': inventaire.service,
        'bureau': inventaire.bureau,
        'barcode': inventaire.scan,
        'date': inventaire.date,
        'materiel': inventaire.materiel,
        'utilisateur': inventaire.utilisateur
      },
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future deleteExistingInventaires(List<String> nos) async {
    var databasesPath = await getDatabasesPath();
    String path = "$databasesPath/inventaire.db";
    var database = await openDatabase(path, version: 2);
    for (var no in nos) {
      await database.delete('Inventaires', where: 'no = ?', whereArgs: [no]);
    }
  }

  Future updateInventaire(Inventaire inventaire) async {
    var databasesPath = await getDatabasesPath();
    String path = "$databasesPath/inventaire.db";
    var database = await openDatabase(path, version: 2);
    database.update(
        'Inventaires',
        {
          'service': inventaire.service,
          'bureau': inventaire.bureau,
          'barcode': inventaire.scan,
          'date': inventaire.date,
          'materiel': inventaire.materiel,
          'utilisateur': inventaire.utilisateur
        },
        where: 'no = ?',
        whereArgs: [inventaire.no]);
  }

  Future<Map<String, dynamic>?> getCurrentInventaireConfig() async {
    var databasesPath = await getDatabasesPath();
    // String path = join(databasesPath, 'demo.db');
    String path = "$databasesPath/inventaire.db";
    var database = await openDatabase(path, version: 2);

    var list = await database.query('IventaireConfig',
        where: "isActive = ?", whereArgs: [1], limit: 1);

    if (list.isNotEmpty) {
      return list.first;
    }
    return null;
  }

  Future<List<Map>> getInventaire(String no) async {
    var databasesPath = await getDatabasesPath();
    // String path = join(databasesPath, 'demo.db');
    String path = "$databasesPath/inventaire.db";
    var database = await openDatabase(path, version: 2);

    List<Map> list =
        await database.query('Inventaires', where: "no = ?", whereArgs: [no]);

    return list;

    // if (list.length > 0) {
    //   return list.first;
    // }
    // return null;
  }

  Future<List<Map>> getInventaires() async {
    var databasesPath = await getDatabasesPath();
    // String path = join(databasesPath, 'demo.db');
    String path = "$databasesPath/inventaire.db";
    var database = await openDatabase(path, version: 2);
    List<Map> inventaires =
        await database.rawQuery('SELECT * FROM IventaireConfig');
    return inventaires;
  }

  Future addInventaireConfig(InventaireItem item) async {
    var databasesPath = await getDatabasesPath();
    // var uuid = const Uuid();
    String path = "$databasesPath/inventaire.db";
    var database = await openDatabase(path, version: 2);
    database.insert(
      'IventaireConfig',
      {'id': item.id, 'no': item.no, 'isActive': item.isActive == true ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future updateInventaireConfig(InventaireItem item) async {
    var databasesPath = await getDatabasesPath();
    String path = "$databasesPath/inventaire.db";
    var database = await openDatabase(path, version: 2);
    database.update('IventaireConfig',
        {'no': item.no, 'isActive': item.isActive == true ? 1 : 0},
        where: 'id = ?', whereArgs: [item.id]);
  }

  Future archiveInventairesConfig(List<String> ids) async {
    var databasesPath = await getDatabasesPath();
    String path = "$databasesPath/inventaire.db";
    var database = await openDatabase(path, version: 2);
    database.update('IventaireConfig', {'isActive': false},
        where: 'id = ?', whereArgs: ids);
  }

  static List<Service> defaultServices = [
    Service(name: 'AGENCE PACTE', localisation: 'AGENCE PACTE'),
    Service(name: 'BNI 9EME TRANCHE', localisation: 'BNI 9EME TRANCHE'),
    Service(name: 'BNI ABATTA', localisation: 'BNI ABATTA'),
    Service(name: 'BNI ABENGOUROU', localisation: 'BNI ABENGOUROU'),
    Service(name: 'BNI ABOBO', localisation: 'BNI ABOBO'),
    Service(name: 'BNI ABOBO PK 18', localisation: 'BNI ABOBO PK 18'),
    Service(name: 'BNI ADJAMÉ', localisation: 'BNI ADJAMÉ'),
    Service(
        name: 'BNI ADJAMÉ SAINT-MICHEL',
        localisation: 'BNI ADJAMÉ SAINT-MICHEL'),
    Service(name: 'BNI BASSAM', localisation: 'BNI BASSAM'),
    Service(name: 'BNI BONON', localisation: 'BNI BONON'),
    Service(name: 'BNI BONOUA', localisation: 'BNI BONOUA'),
    Service(name: 'BNI BOUAKÉ COMMERCE', localisation: 'BNI BOUAKÉ COMMERCE'),
    Service(
        name: 'BNI BOUAKÉ MARCHÉ DE GROS',
        localisation: 'BNI BOUAKÉ MARCHÉ DE GROS'),
    Service(name: 'BNI BOUNDIALI', localisation: 'BNI BOUNDIALI'),
    Service(name: 'BNI DABOU', localisation: 'BNI DABOU'),
    Service(name: 'BNI DALOA', localisation: 'BNI DALOA'),
    Service(name: 'BNI DANGA', localisation: 'BNI DANGA'),
    Service(name: 'BNI EHANIA', localisation: 'BNI EHANIA'),
    Service(name: 'BNI FERKESSÉDOUGOU', localisation: 'BNI FERKESSEDOU'),
    Service(name: 'BNI GAGNOA', localisation: 'BNI GAGNOA'),
    Service(name: 'BNI IBOKE', localisation: 'BNI IBOKE'),
    Service(name: 'BNI II PLATEAUX AGBAN', localisation: 'BNI DEUX-PLATEA'),
    Service(name: 'BNI II PLATEAUX LATRILLE', localisation: 'BNI DEUX-PLATEA'),
    Service(name: 'BNI IROBO', localisation: 'BNI IROBO'),
    Service(name: 'BNI KORHOGO', localisation: 'BNI KORHOGO'),
    Service(name: 'BNI KOUMASSI', localisation: 'BNI KOUMASSI'),
    Service(name: 'BNI MAN', localisation: 'BNI MAN'),
    Service(name: 'BNI MÉAGUI', localisation: 'BNI MEAGUI'),
    Service(name: 'BNI PLATEAU ALLIANCE', localisation: 'BNI PLATEAU ALL'),
    Service(name: 'BNI PLATEAU RÉPUBLIQUE', localisation: 'BNI PLATEAU REP'),
    Service(name: 'BNI PRESTIGE', localisation: 'BNI PRESTIGE'),
    Service(name: 'BNI RIVIERA 3', localisation: 'BNI RIVIERA 3'),
    Service(name: 'BNI RIVIERA MPOUTO', localisation: 'BNI MPOUTO'),
    Service(name: 'BNI RIVIERA PALMERAIE', localisation: 'BNI RIVIERA PAL'),
    Service(name: 'BNI SAN-PÉDRO PORT', localisation: 'BNI SAN-PEDRO'),
    Service(name: 'BNI SOUBRE', localisation: 'BNI SOUBRE'),
    Service(name: 'BNI TONGON', localisation: 'BNI TONGON'),
    Service(name: 'BNI TREICHVILLE', localisation: 'BNI TREICHVILLE'),
    Service(name: 'BNI YAMOUSSOUKRO', localisation: 'BNI YAMOUSSOUKRO'),
    Service(name: 'BNI YOPOUGON', localisation: 'BNI YOPOUGON KE'),
    Service(name: 'BNI YOPOUGON COSMOS', localisation: 'BNI YOPOUGON CO'),
    Service(
        name: 'BNI YOPOUGON NIANGON LUBAFRIQUE',
        localisation: 'BNI YOPOUGON NI'),
    Service(name: 'BNI ZONE 4', localisation: 'BNI ZONE 4'),
    Service(name: 'SERVICE CLIENTÈLE JA', localisation: 'BNI RUE DES BAN')
  ];
}
