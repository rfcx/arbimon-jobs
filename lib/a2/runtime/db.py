import contextlib
import MySQLdb
import MySQLdb.cursors
import a2pyutils.config

# db connection
__=object()


def cursor():
    return contextlib.closing(get_db().cursor())

def execute(sql, *args):
    sql = sql.strip()
    with cursor() as c:
        c.execute(sql, *args)
        return c.fetchall()

def queryOne(sql, *args):
    sql = sql.strip()
    with cursor() as c:
        c.execute(sql, *args)
        return c.fetchone()

def queryGen(sql, *args):
    sql = sql.strip()
    with cursor() as c:
        c.execute(sql, *args)
        for r in c:
            yield r

def commit():
    get_db().commit()
    

def get_db():
    """Returns a database connection instance."""
    if __.connection:
        return __.connection
        
    config = a2pyutils.config.EnvironmentConfig()
        
    __.connection = MySQLdb.connect(
        host=config.dbConfig['host'], user=config.dbConfig['user'], 
        passwd=config.dbConfig['password'], db=config.dbConfig['database'],
        cursorclass=MySQLdb.cursors.DictCursor
    )
    
    return __.connection

def close():
    if __.connection:
        __.connection.close()
        __.connection = None
