require( "mysqloo" )

ResistanceRP.Database = {}
ResistanceRP.Database.DatabaseHostname = "localhost"
ResistanceRP.Database.DatabaseUser = "root"
ResistanceRP.Database.DatabasePass = ""
ResistanceRP.Database.DatabaseName = "gmod_rrp"
ResistanceRP.Database.DatabasePort = 3306


db = mysqloo.connect(ResistanceRP.Database.DatabaseHostname, ResistanceRP.Database.DatabaseUser, ResistanceRP.Database.DatabasePass, ResistanceRP.Database.DatabaseName, ResistanceRP.Database.DatabasePort)

function db:onConnected()
    ResistanceRP.Print("Successfully connected to database: "..ResistanceRP.Database.DatabaseName)

    local query = self:query("CREATE TABLE IF NOT EXISTS RRP_Players (playerID VARCHAR(17) PRIMARY KEY, characters TEXT, playIntroduction BOOLEAN)")
    query:start()
end

function db:onConnectionFailed( err )
    ResistanceRP.Print( "Connection to database failed!" )
    ResistanceRP.Print( "Error:", err )
end
db:connect()