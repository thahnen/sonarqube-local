class SonarqubeDev89 < Formula
  desc "Manage code quality (Developer Edition) 8.9 LTS"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/CommercialDistribution/sonarqube-developer/sonarqube-developer-8.9.10.61524.zip"
  sha256 "c4413d008f8057104e77a156c4f49d9de4843e2ecb478a2b17fc80f8f324eff4"
  license "LGPL-3.0-or-later"

  depends_on "openjdk@17"

  def install
    platform = OS.mac? ? "macosx-universal-64" : "linux-x86-64"

    inreplace buildpath/"bin"/platform/"sonar.sh",
      %r{^PIDFILE="\$PIDDIR/\$APP_NAME\.pid"$},
      "PIDFILE=#{var}/sonarqube-dev-89/$APP_NAME.pid"

    inreplace "conf/sonar.properties" do |s|
      # Write log/data/temp files outside of installation directory
      s.sub!(/^#sonar\.path\.data=.*/, "sonar.path.data=#{var}/sonarqube-dev-89/data")
      s.sub!(/^#sonar\.path\.logs=.*/, "sonar.path.logs=#{var}/sonarqube-dev-89/logs")
      s.sub!(/^#sonar\.path\.temp=.*/, "sonar.path.temp=#{var}/sonarqube-dev-89/temp")
    end

    libexec.install Dir["*"]
    env = Language::Java.overridable_java_home_env("17")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"sonarqube-dev-89").write_env_script libexec/"bin"/platform/"sonar.sh", env
  end

  def post_install
    (var/"sonarqube-dev-89/logs").mkpath
  end

  def caveats
    <<~EOS
      Data: #{var}/sonarqube-dev-89/data
      Logs: #{var}/sonarqube-dev-89/logs
      Temp: #{var}/sonarqube-dev-89/temp
    EOS
  end

  service do
    # in case of instances running, stop them all
    run [opt_bin/"brew", "services", "stop", "sonarqube"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dev"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dev-79"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dev-99"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-ent"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dat"]

    run [opt_bin/"sonarqube-dev-89", "console"]
    keep_alive true
  end
end
