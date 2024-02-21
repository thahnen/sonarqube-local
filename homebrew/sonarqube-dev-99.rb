class SonarqubeDev99 < Formula
  desc "Manage code quality (Developer Edition) 9.9 LTS"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/CommercialDistribution/sonarqube-developer/sonarqube-developer-9.9.4.87374.zip"
  sha256 "72a0c8aa76e9b65db52895e5e34107478ebc6ddd4c4fa3d0fe443c2453158ad2"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/page-data.json"
    regex(/sonarqube-developer-9[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  depends_on "openjdk@17"

  def install
    platform = OS.mac? ? "macosx-universal-64" : "linux-x86-64"

    inreplace buildpath/"bin"/platform/"sonar.sh",
      %r{^PIDFILE="\./\$APP_NAME\.pid"$},
      "PIDFILE=#{var}/sonarqube-dev-99/$APP_NAME.pid"

    inreplace "conf/sonar.properties" do |s|
      # Write log/data/temp files outside of installation directory
      s.sub!(/^#sonar\.path\.data=.*/, "sonar.path.data=#{var}/sonarqube-dev-99/data")
      s.sub!(/^#sonar\.path\.logs=.*/, "sonar.path.logs=#{var}/sonarqube-dev-99/logs")
      s.sub!(/^#sonar\.path\.temp=.*/, "sonar.path.temp=#{var}/sonarqube-dev-99/temp")
    end

    libexec.install Dir["*"]
    env = Language::Java.overridable_java_home_env("17")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"sonarqube-dev-99").write_env_script libexec/"bin"/platform/"sonar.sh", env
  end

  def post_install
    (var/"sonarqube-dev-99/logs").mkpath
  end

  def caveats
    <<~EOS
      Data: #{var}/sonarqube-dev-99/data
      Logs: #{var}/sonarqube-dev-99/logs
      Temp: #{var}/sonarqube-dev-99/temp
    EOS
  end

  service do
    # in case of instances running, stop them all
    run [opt_bin/"brew", "services", "stop", "sonarqube"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dev"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dev-79"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dev-89"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-ent"]
    run [opt_bin/"brew", "services", "stop", "sonarqube-dat"]

    run [opt_bin/"sonarqube-dev-99", "console"]
    keep_alive true
  end
end
