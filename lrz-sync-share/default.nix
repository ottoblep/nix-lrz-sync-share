{ stdenv
, fetchurl
, jre
}:

stdenv.mkDerivation rec {
  pname = "lrz-sync-share";
  version = "19.2.100";

  src = fetchurl {
    url = "https://syncandshare.lrz.de/client_deployment/LRZ_Sync_Share_Latest_Linux.tar.gz";
    hash = "sha256-1OCni1lDW4YLs+ONe+s4XSnk4qFxv6Yx4zMLQ2cHibg=";
  };

  installPhase = ''
    echo "Installing LRZ Sync+Share $DIST_VER"
    mkdir -p $out/bin $out/lib/lrz-sync-share
    cp -vr ./jre/lib $out/lib/lrz-sync-share
    cp -v ./LRZ_Sync_Share.jar $out/bin/LRZ_Sync_Share.jar

    # Required since open JDK 17 or newer
    JAVA_ADD="--add-exports=java.base/sun.nio.ch=ALL-UNNAMED"
    JAVA_ADD="$JAVA_ADD --add-opens=java.base/java.lang=ALL-UNNAMED"
    JAVA_ADD="$JAVA_ADD --add-opens=java.base/java.lang.reflect=ALL-UNNAMED"
    JAVA_ADD="$JAVA_ADD --add-opens=java.base/java.io=ALL-UNNAMED"
    JAVA_ADD="$JAVA_ADD --add-exports=jdk.unsupported/sun.misc=ALL-UNNAMED"
    JAVA_ADD="$JAVA_ADD --add-exports=java.desktop/sun.swing=ALL-UNNAMED"
    JAVA_ADD="$JAVA_ADD --add-opens=java.desktop/javax.swing.plaf.synth=ALL-UNNAMED"
    JAVA_ADD="$JAVA_ADD --add-opens=java.desktop/javax.swing.plaf.basic=ALL-UNNAMED"
    JAVA_ADD="$JAVA_ADD --add-exports=java.desktop/sun.swing.plaf.synth=ALL-UNNAMED"
    JAVA_ADD="$JAVA_ADD --add-exports=java.desktop/sun.swing.table=ALL-UNNAMED"

    # JAVA_MEM specifies some memory settings vor the Java
    # virtual machine
    #
    # If running on a 64-bit system with more than 4GB ram
    # or if facing an out-of-memory error the value for the
    # -Xmx parameter can be raised (example: -Xmx4g,-Xmx8g,
    # -Xmx6g,...), so the virtual machine will be allowed
    # to use more memory during runtime.
    JAVA_MEM="-Xms64m -Xmx2g -XX:NewRatio=8 -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20"

    # Set classpath
    CP="$out/bin/LRZ_Sync_Share.jar:$out/lib/lrz-sync-share/*"

    cat > $out/bin/lrz-sync-share << EOF
    #!/bin/sh
    USER_HOME="$(echo -n $(bash -c "cd ~ && pwd"))"
    exec ${jre}/bin/java $JAVA_ADD $JAVA_MEM -Duser.home=$USER_HOME -cp $CP de.dal33t.Start 
    EOF

    chmod +x $out/bin/lrz-sync-share
  '';

}
