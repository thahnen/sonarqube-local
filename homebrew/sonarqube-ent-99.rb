class SonarqubeEnt99 < Formula
  desc "Manage code quality (Enterprise Edition) 9.9 LTS"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/CommercialDistribution/sonarqube-enterprise/sonarqube-enterprise-9.9.4.87374.zip"
  sha256 "bd6ea879c5a6761274f7ae777e8efcc53dfa00fd030949ed5516768b52c150a6"
  license "LGPL-3.0-or-later"

  livecheck do
      url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/page-data.json"
    regex(/sonarqube-enterprise-9[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  depends_on "openjdk@17"

  def install
    platform = OS.mac? ? "macosx-universal-64" : "linux-x86-64"

    inreplace buildpath/"bin"/platform/"sonar.sh",
      %r{^PIDFILE="\./\$APP_NAME\.pid"$},
      "PIDFILE=#{var}/sonarqube-ent-99/$APP_NAME.pid"

    inreplace "conf/sonar.properties" do |s|
      # Write log/data/temp files outside of installation directory
      s.sub!(/^#sonar\.path\.data=.*/, "sonar.path.data=#{var}/sonarqube-ent-99/data")
      s.sub!(/^#sonar\.path\.logs=.*/, "sonar.path.logs=#{var}/sonarqube-ent-99/logs")
      s.sub!(/^#sonar\.path\.temp=.*/, "sonar.path.temp=#{var}/sonarqube-ent-99/temp")
    end

    libexec.install Dir["*"]
    env = Language::Java.overridable_java_home_env("17")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"sonarqube-ent-99").write_env_script libexec/"bin"/platform/"sonar.sh", env
  end

  def post_install
    (var/"sonarqube-ent-99/logs").mkpath
  end

  def caveats
    <<~EOS
      Data: #{var}/sonarqube-ent-99/data
      Logs: #{var}/sonarqube-ent-99/logs
      Temp: #{var}/sonarqube-ent-99/temp
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
    run [opt_bin/"brew", "services", "stop", "sonarqube-ent-79"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-ent-89"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dat"]

    run [opt_bin/"sonarqube-ent-99", "console"]
    keep_alive true
  end
end
  