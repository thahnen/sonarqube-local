class SonarqubeDev < Formula
  desc "Manage code quality (Developer Edition)"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/CommercialDistribution/sonarqube-developer/sonarqube-developer-10.4.0.87286.zip"
  sha256 "cca2105d3f14bb04db491fe4207a9aa8364091cd4966eccdcb3e79b8c26eac81"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/page-data.json"
    regex(/sonarqube-developer[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  depends_on "openjdk@17"

  def install
    platform = OS.mac? ? "macosx-universal-64" : "linux-x86-64"

    inreplace buildpath/"bin"/platform/"sonar.sh",
      %r{^PIDFILE="\$PIDDIR/\$APP_NAME\.pid"$},
      "PIDFILE=#{var}/sonarqube-dev/$APP_NAME.pid"

    inreplace "conf/sonar.properties" do |s|
      # Write log/data/temp files outside of installation directory
      s.sub!(/^#sonar\.path\.data=.*/, "sonar.path.data=#{var}/sonarqube-dev/data")
      s.sub!(/^#sonar\.path\.logs=.*/, "sonar.path.logs=#{var}/sonarqube-dev/logs")
      s.sub!(/^#sonar\.path\.temp=.*/, "sonar.path.temp=#{var}/sonarqube-dev/temp")
    end

    libexec.install Dir["*"]
    env = Language::Java.overridable_java_home_env("17")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"sonar-dev").write_env_script libexec/"bin"/platform/"sonar.sh", env
  end

  def post_install
    (var/"sonarqube-dev/logs").mkpath
  end

  def caveats
    <<~EOS
      Data: #{var}/sonarqube-dev/data
      Logs: #{var}/sonarqube-dev/logs
      Temp: #{var}/sonarqube-dev/temp
    EOS
  end

  service do
    # in case of instances running, stop them all
    run [opt_bin/"brew", "services", "stop", "sonarqube"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-ent"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dat"]

    run [opt_bin/"sonar-dev", "console"]
    keep_alive true
  end
end
