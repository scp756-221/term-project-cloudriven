package proj756

import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._

object Utility {
  /*
    Utility to get an Int from an environment variable.
    Return defInt if the environment var does not exist
    or cannot be converted to a string.
  */
  def envVarToInt(ev: String, defInt: Int): Int = {
    try {
      sys.env(ev).toInt
    } catch {
      case e: Exception => defInt
    }
  }

  /*
    Utility to get an environment variable.
    Return defStr if the environment var does not exist.
  */
  def envVar(ev: String, defStr: String): String = {
    sys.env.getOrElse(ev, defStr)
  }
}

object RMusic {

  val feeder = csv("music.csv").eager.random

  val rmusic = forever("i") {
    feed(feeder)
    .exec(http("RMusic ${i}")
      .get("/api/v1/music/${UUID}"))
      .pause(1)
  }

}

object RUser {

  val feeder = csv("users.csv").eager.circular

  val ruser = forever("i") {
    feed(feeder)
    .exec(http("RUser ${i}")
      .get("/api/v1/user/${UUID}"))
      .pause(1)
  }

}

// Scenario object for UpdateUser (s1)
object UUser {

  val feeder = csv("users.csv").eager.circular

  val uuser = forever("i") {
    feed(feeder)
    .exec(http("UUser ${i}")
      .put("/api/v1/user/${UUID}"))
      .pause(1)
  }

}


// Scenario object for WriteMusic (s2)
object WMusic {

  val feeder = csv("music.csv").eager.random

  val wmusic = forever("i") {
    feed(feeder)
    .exec(http("WMusic ${i}")
      .post("/api/v1/music/"))
      .pause(1)
  }

}



// Scenario object for ReadPlaylist (s3)
object RPlaylist {

  val feeder = csv("playlist.csv").eager.random

  val rplaylist = forever("i") {
    feed(feeder)
    .exec(http("RPlaylist ${i}")
      .get("/api/v1/playlist/${UUID}"))
      .pause(1)
  }

}



/*
  After one S1 read, pause a random time between 1 and 60 s
*/
object RUserVarying {
  val feeder = csv("users.csv").eager.circular

  val ruser = forever("i") {
    feed(feeder)
    .exec(http("RUserVarying ${i}")
      .get("/api/v1/user/${UUID}"))
    .pause(1, 60)
  }
}

/*
  After one S2 read, pause a random time between 1 and 60 s
*/

object RMusicVarying {
  val feeder = csv("music.csv").eager.circular

  val rmusic = forever("i") {
    feed(feeder)
    .exec(http("RMusicVarying ${i}")
      .get("/api/v1/music/${UUID}"))
    .pause(1, 60)
  }
}

/*
  Failed attempt to interleave reads from User and Music tables.
  The Gatling EDSL only honours the second (Music) read,
  ignoring the first read of User. [Shrug-emoji] 
 */
object RBoth {

  val u_feeder = csv("users.csv").eager.circular
  val m_feeder = csv("music.csv").eager.random

  val rboth = forever("i") {
    feed(u_feeder)
    .exec(http("RUser ${i}")
      .get("/api/v1/user/${UUID}"))
    .pause(1);

    feed(m_feeder)
    .exec(http("RMusic ${i}")
      .get("/api/v1/music/${UUID}"))
      .pause(1)
  }

}

// Get Cluster IP from CLUSTER_IP environment variable or default to 127.0.0.1 (Minikube)
class ReadTablesSim extends Simulation {
  val httpProtocol = http
    .baseUrl("http://" + Utility.envVar("CLUSTER_IP", "127.0.0.1") + "/")
    .acceptHeader("application/json,text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
    .authorizationHeader("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZGJmYmMxYzAtMDc4My00ZWQ3LTlkNzgtMDhhYTRhMGNkYTAyIiwidGltZSI6MTYwNzM2NTU0NC42NzIwNTIxfQ.zL4i58j62q8mGUo5a0SQ7MHfukBUel8yl8jGT5XmBPo")
    .acceptLanguageHeader("en-US,en;q=0.5")
}
/*
// Added as an addiontal load test scenario (Update Table Simulation) for s1
class UpdateTablesSimS1 extends Simulation {
  val httpProtocol = http
    .baseUrl("http://" + Utility.envVar("CLUSTER_IP", "127.0.0.1") + "/")
    .postData("""{"email":"cmpt756@sfu.ca","fname":"cloudriven","lname":"CMPT"}""")
    .acceptHeader("application/json,text/html,application/xhtml+xml,application/xml;q=0.9,**;q=0.8")
    .authorizationHeader("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZGJmYmMxYzAtMDc4My00ZWQ3LTlkNzgtMDhhYTRhMGNkYTAyIiwidGltZSI6MTYwNzM2NTU0NC42NzIwNTIxfQ.zL4i58j62q8mGUo5a0SQ7MHfukBUel8yl8jGT5XmBPo")
    .acceptLanguageHeader("en-US,en;q=0.5")
}
/**
// Added as an addiontal load test scenario (Update Table Simulation) for s2
class UpdateTablesSimS2 extends Simulation {
  val httpProtocol = http
    .baseUrl("http://" + Utility.envVar("CLUSTER_IP", "127.0.0.1") + "/")
    .postData("""{"Artist":"BTS","SongTitle":"Butter"}""")
    .acceptHeader("application/json,text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
    .authorizationHeader("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZGJmYmMxYzAtMDc4My00ZWQ3LTlkNzgtMDhhYTRhMGNkYTAyIiwidGltZSI6MTYwNzM2NTU0NC42NzIwNTIxfQ.zL4i58j62q8mGUo5a0SQ7MHfukBUel8yl8jGT5XmBPo")
    .acceptLanguageHeader("en-US,en;q=0.5")
}
**/
class ReadUserSim extends ReadTablesSim {
  val scnReadUser = scenario("ReadUser")
      .exec(RUser.ruser)

  setUp(
    scnReadUser.inject(atOnceUsers(Utility.envVarToInt("USERS", 1)))
  ).protocols(httpProtocol)
}

class ReadMusicSim extends ReadTablesSim {
  val scnReadMusic = scenario("ReadMusic")
    .exec(RMusic.rmusic)

  setUp(
    scnReadMusic.inject(atOnceUsers(Utility.envVarToInt("USERS", 1)))
  ).protocols(httpProtocol)
}
/*
// A new simulation that continuously calls update_user() with a specific interval. (HTTP PUT requests)
class UpdateUserSim extends UpdateTablesSimS1 {
  val scnUpdateUser = scenario("UpdateUser")
      .exec(UUser.uuser)

  setUp(
    scnUpdateUser.inject(atOnceUsers(Utility.envVarToInt("USERS", 1)))
  ).protocols(httpProtocol)
}


// A new simulation that constantly calls create_song() with a specific interval. (HTTP POST requests)
class WriteMusicSim extends UpdateTablesSimS2 {
  val scnWriteMusic = scenario("WriteMusic")
    .exec(WMusic.wmusic)

  setUp(
    scnWriteMusic.inject(atOnceUsers(Utility.envVarToInt("USERS", 1)))
  ).protocols(httpProtocol)
}
*/

// a new simulation that constantly calls get_playlist() with a specific interval. (HTTP GET requests)
class ReadPlaylistSim extends ReadTablesSim {
  val scnReadPlaylist = scenario("ReadPlaylist")
      .exec(RPlaylist.rplaylist)

  setUp(
    scnReadPlaylist.inject(atOnceUsers(Utility.envVarToInt("USERS", 1)))
  ).protocols(httpProtocol)
}


/*
  Read both services concurrently at varying rates.
  Ramp up new users one / 10 s until requested USERS
  is reached for each service.
*/
class ReadBothVaryingSim extends ReadTablesSim {
  val scnReadMV = scenario("ReadMusicVarying")
    .exec(RMusicVarying.rmusic)

  val scnReadUV = scenario("ReadUserVarying")
    .exec(RUserVarying.ruser)

  val users = Utility.envVarToInt("USERS", 10)

  setUp(
    // Add one user per 10 s up to specified value
    scnReadMV.inject(rampConcurrentUsers(1).to(users).during(10*users)),
    scnReadUV.inject(rampConcurrentUsers(1).to(users).during(10*users))
  ).protocols(httpProtocol)
}

/*
  This doesn't work---it just reads the Music table.
  We left it in here as possible inspiration for other work
  (or a warning that this approach will fail).
 */
/*
class ReadBothSim extends ReadTablesSim {
  val scnReadBoth = scenario("ReadBoth")
    .exec(RBoth.rboth)

  setUp(
    scnReadBoth.inject(atOnceUsers(1))
  ).protocols(httpProtocol)
}
*/
