class SonarqubeEnt < Formula
  desc "Manage code quality (Enterprise Edition)"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/CommercialDistribution/sonarqube-enterprise/sonarqube-enterprise-10.4.0.87286.zip"
  sha256 "22569a4abc85e27f6410f74af8c7a0de015ba46e83aab68c063690c62e6a9aa6"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/success-download-enterprise-edition/page-data.json"
    regex(/sonarqube-enterprise[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  depends_on "openjdk@17"

  def install
    platform = OS.mac? ? "macosx-universal-64" : "linux-x86-64"

    inreplace buildpath/"bin"/platform/"sonar.sh",
      %r{^PIDFILE="\$PIDDIR/\$APP_NAME\.pid"$},
      "PIDFILE=#{var}/sonarqube-ent/$APP_NAME.pid"

    inreplace "conf/sonar.properties" do |s|
      # Write log/data/temp files outside of installation directory
      s.sub!(/^#sonar\.path\.data=.*/, "sonar.path.data=#{var}/sonarqube-ent/data")
      s.sub!(/^#sonar\.path\.logs=.*/, "sonar.path.logs=#{var}/sonarqube-ent/logs")
      s.sub!(/^#sonar\.path\.temp=.*/, "sonar.path.temp=#{var}/sonarqube-ent/temp")
    end

    libexec.install Dir["*"]
    env = Language::Java.overridable_java_home_env("17")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"sonarqube-ent").write_env_script libexec/"bin"/platform/"sonar.sh", env
  end

  def post_install
    (var/"sonarqube-ent/logs").mkpath
  end

  def caveats
    <<~EOS
      Data: #{var}/sonarqube-ent/data
      Logs: #{var}/sonarqube-ent/logs
      Temp: #{var}/sonarqube-ent/temp
    EOS
  end

  service do
    # in case of instances running, stop them all
    run [opt_bin/"brew", "services", "stop", "sonarqube"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dev"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dev-79"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dev-89"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dev-99"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-ent-79"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-ent-89"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-ent-99"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dat"]

    run [opt_bin/"sonarqube-ent", "console"]
    keep_alive true
  end
end
