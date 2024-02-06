class SonarqubeEnt < Formula
  desc "Manage code quality (Enterprise Edition)"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/CommercialDistribution/sonarqube-enterprise/sonarqube-enterprise-10.4.0.87286.zip"
  sha256 "09f31dd7f1c485b97ac3b5739d5460de62a4d99937b06ee59b4a3800a65d3405"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/page-data.json"
    regex(/sonarqube-enterprise[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  depends_on "openjdk@17"

  def install
    platform = OS.mac? ? "macosx-universal-64" : "linux-x86-64"

    inreplace buildpath/"bin"/platform/"sonar.sh",
      %r{^PIDFILE="\./\$APP_NAME\.pid"$},
      "PIDFILE=#{var}/run-ent/$APP_NAME.pid"

    inreplace "conf/sonar.properties" do |s|
      # Write log/data/temp files outside of installation directory
      s.sub!(/^#sonar\.path\.data=.*/, "sonar.path.data=#{var}/sonarqube-ent/data")
      s.sub!(/^#sonar\.path\.logs=.*/, "sonar.path.logs=#{var}/sonarqube-ent/logs")
      s.sub!(/^#sonar\.path\.temp=.*/, "sonar.path.temp=#{var}/sonarqube-ent/temp")
    end

    libexec.install Dir["*"]
    env = Language::Java.overridable_java_home_env("17")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"sonar-ent").write_env_script libexec/"bin"/platform/"sonar.sh", env
  end

  def post_install
    (var/"run-ent").mkpath
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
    run [opt_bin/"brew", "services", "stop", "sonarqube-dat"]

    run [opt_bin/"sonar-ent", "console"]
    keep_alive true
  end
end
