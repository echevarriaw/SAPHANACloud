import java.sql.*;
public class query {
    public static void main(String[] argv) {
        Connection connection = null;
        try {
            connection = DriverManager.getConnection("jdbc:sap://<endpoint>/?encrypt=true", "<user>", "<password>");
        }
        catch (SQLException e) {
            System.err.println("Connection to SAP HANA Cloud Failed:");
            System.err.println(e);
            return;
        }
        if (connection != null) {
            try {
                System.out.println("Connected to SAP HANA Cloud!");
                Statement stmt = connection.createStatement();
                ResultSet resultSet = stmt.executeQuery("SELECT * FROM travel.budgetrooms");
                while (resultSet.next()) {
                    System.out.println(resultSet.getString(1) + " " + resultSet.getString(2) + " " + resultSet.getString(3) + " " + resultSet.getString(4) + " " + resultSet.getString(5) + " " + resultSet.getString(6));
                }
            }
            catch (SQLException e) {
                System.err.println("Query failed!");
            }
        }
    }
}
