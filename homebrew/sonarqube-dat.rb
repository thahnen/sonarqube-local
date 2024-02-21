class SonarqubeDat < Formula
  desc "Manage code quality (Datacenter Edition)"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/CommercialDistribution/sonarqube-datacenter/sonarqube-datacenter-10.4.0.87286.zip"
  sha256 "f80e9389b543928566b1619a4d4b050276ef08d98939d9e4ac33807f011e6d95"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/success-download-data-center-edition/page-data.json"
    regex(/sonarqube-datacenter[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  depends_on "openjdk@17"

  def install
    platform = OS.mac? ? "macosx-universal-64" : "linux-x86-64"

    inreplace buildpath/"bin"/platform/"sonar.sh",
      %r{^PIDFILE="\$PIDDIR/\$APP_NAME\.pid"$},
      "PIDFILE=#{var}/sonarqube-dat/$APP_NAME.pid"

    inreplace "conf/sonar.properties" do |s|
      # Write log/data/temp files outside of installation directory
      s.sub!(/^#sonar\.path\.data=.*/, "sonar.path.data=#{var}/sonarqube-dat/data")
      s.sub!(/^#sonar\.path\.logs=.*/, "sonar.path.logs=#{var}/sonarqube-dat/logs")
      s.sub!(/^#sonar\.path\.temp=.*/, "sonar.path.temp=#{var}/sonarqube-dat/temp")
    end

    libexec.install Dir["*"]
    env = Language::Java.overridable_java_home_env("17")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"sonarqube-dat").write_env_script libexec/"bin"/platform/"sonar.sh", env
  end

  def post_install
    (var/"sonarqube-dat/logs").mkpath
  end

  def caveats
    <<~EOS
      Data: #{var}/sonarqube-dat/data
      Logs: #{var}/sonarqube-dat/logs
      Temp: #{var}/sonarqube-dat/temp
    EOS
  end

  service do
    # in case of instances running, stop them all
    run [opt_bin/"brew", "services", "stop", "sonarqube"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dev"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dev-79"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dev-89"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dev-99"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-ent"]

    run [opt_bin/"sonarqube-dat", "console"]
    keep_alive true
  end
end
