package Utility;

import java.io.IOException;
import java.io.InputStream;
import static java.lang.String.format;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ConnectionManager {

    private static final String PROPS_FILENAME = "connection.properties";
    private static String dbUser;
    private static String dbPassword;
    private static String dbURL;

    static {
        readDatabaseProperties();
        initDBDriver();
    }

    /**
     * Retrieve properties from connection.properties via the CLASSPATH
    *
     */
    private static void readDatabaseProperties() {
        InputStream is = null;
        try {
            // Retrieve properties from connection.properties via the CLASSPATH
            // WEB-INF/classes is on the CLASSPATH

            Properties props = new Properties();
            is = ConnectionManager.class.getResourceAsStream("/" + PROPS_FILENAME);

            if (is == null) {
                throw new IllegalArgumentException(format("Could not load '%s'. Missing File?", PROPS_FILENAME));
            } else {
                props.load(is);
            }

            String host = props.getProperty("db.host");
            String port = props.getProperty("db.port");
            String dbName = props.getProperty("db.name");
            dbUser = props.getProperty("db.user");

            // grab environment variable to check if we are on production environment
            String username = System.getProperty("os.name");
            if (username.equals("Linux")) {
                // in production environment, use aws.db.password
                dbPassword = props.getProperty("aws.db.password");
            } else {
                // in local environment, use db.password
                dbPassword = props.getProperty("db.password");
            }
            dbURL = "jdbc:mysql://" + host + ":" + port + "/" + dbName;
        } catch (IllegalArgumentException | IOException ex) {
            // unable to load properties file
            String message = "Unable to load '" + PROPS_FILENAME + "'.";
            System.out.println(message);
            Logger.getLogger(ConnectionManager.class.getName()).log(Level.SEVERE, message, ex);
            throw new RuntimeException(message, ex);
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException ex) {
                    Logger.getLogger(ConnectionManager.class.getName()).log(Level.WARNING, "Unable to close connection.properties", ex);
                }
            }
        }
    }

    /**
     * Creates an instance of JDBC driver
     *
     *
     */
    private static void initDBDriver() {
        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
        } catch (ClassNotFoundException | InstantiationException | IllegalAccessException ex) {
            //unable to load properties file
            String message = "Unable to find JDBC driver for MySQL.";
            System.out.println(message);
            Logger.getLogger(ConnectionManager.class.getName()).log(Level.SEVERE, message, ex);
            throw new RuntimeException(message, ex);
        }
    }

    /**
     * Gets connection to database
     *
     * @return Connection object
     * @throws SQLException when connection is not successful
     */
    public static Connection getConnection() throws SQLException {
        String message = "dbURL: " + dbURL
                + "  , dbUser: " + dbUser
                + "  , dbPassword: " + dbPassword;
        Logger.getLogger(ConnectionManager.class.getName()).log(Level.INFO, message);
        return DriverManager.getConnection(dbURL, dbUser, dbPassword);
    }

    /**
     * Gets connection to local SQL
     *
     * @return Connection if Connection was successful, null if connection was
     * unsuccessful
     * @throws SQLException if Connection was unsuccessful
     */
    public static Connection getConnectionForDropSchema() throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost/", dbUser, dbPassword);
    }

    /**
     * Closes the Connection conn
     *
     * @param conn Connection to be closed
     * @param stmt Statement to be closed
     * @param rs ResultSet to be closed
     */
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (SQLException ex) {
            Logger.getLogger(ConnectionManager.class.getName()).log(Level.WARNING,
                    "Unable to close ResultSet", ex);
        }
        try {
            if (stmt != null) {
                stmt.close();
            }
        } catch (SQLException ex) {
            Logger.getLogger(ConnectionManager.class.getName()).log(Level.WARNING,
                    "Unable to close Statement", ex);
        }
        try {
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException ex) {
            Logger.getLogger(ConnectionManager.class.getName()).log(Level.WARNING,
                    "Unable to close Connection", ex);
        }
    }

    /**
     * Closes the Connection conn
     *
     * @param conn Connection to be closed
     * @param stmt Statement to be closed
     */
    public static void close(Connection conn, Statement stmt) {
        close(conn, stmt, null);
    }

    /**
     * Closes the Connection conn
     *
     * @param conn Connection to be closed
     */
    public static void close(Connection conn) {
        close(conn, null, null);
    }
}
