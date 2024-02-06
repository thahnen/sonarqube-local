class SonarqubeDat < Formula
  desc "Manage code quality (Datacenter Edition)"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/CommercialDistribution/sonarqube-datacenter/sonarqube-datacenter-10.4.0.87286.zip"
  sha256 "2cdbec9904a59330c780b735a9882ffad4d67545b099bbe7de38756737bddfb4"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/page-data.json"
    regex(/sonarqube-datacenter[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  depends_on "openjdk@17"

  def install
    platform = OS.mac? ? "macosx-universal-64" : "linux-x86-64"

    inreplace buildpath/"bin"/platform/"sonar.sh",
      %r{^PIDFILE="\./\$APP_NAME\.pid"$},
      "PIDFILE=#{var}/run-dat/$APP_NAME.pid"

    inreplace "conf/sonar.properties" do |s|
      # Write log/data/temp files outside of installation directory
      s.sub!(/^#sonar\.path\.data=.*/, "sonar.path.data=#{var}/sonarqube-dat/data")
      s.sub!(/^#sonar\.path\.logs=.*/, "sonar.path.logs=#{var}/sonarqube-dat/logs")
      s.sub!(/^#sonar\.path\.temp=.*/, "sonar.path.temp=#{var}/sonarqube-dat/temp")
    end

    libexec.install Dir["*"]
    env = Language::Java.overridable_java_home_env("17")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"sonar-dat").write_env_script libexec/"bin"/platform/"sonar.sh", env
  end

  def post_install
    (var/"run-dat").mkpath
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
    run [opt_bin/"brew", "services", "stop", "sonarqube-ent"]

    run [opt_bin/"sonar-dat", "console"]
    keep_alive true
  end
end
