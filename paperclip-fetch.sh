#!/bin/bash
  
package="paperclip.jar"

oldsum=$(md5sum paperclip.jar | awk '{print $1}')
newsum=$(curl -s 'https://papermc.io/ci/job/Paper-1.16/lastSuccessfulBuild/artifact/paperclip.jar/*fingerprint*/' | ~/go/bin/pup '.md5sum json{}' | jq '.[0].text' -r | awk '{print $2}')

while [[ true ]]; do
        if [[ "$oldsum" != "$newsum" ]]; then
            wget https://papermc.io/ci/job/Paper-1.16/lastSuccessfulBuild/artifact/paperclip.jar -O paperclip.jar
        fi
        
        echo 'System Warning: Please wait 3 seconds for the next server to run. (Ctrl-Z to Stop)'
        for ((delay = 0; delay < 3; delay++)); do
                sleep $delay
        done
        # Java Flags (Aikar's)
        java -Xms8G -Xmx8G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=20 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -Dfile.encoder=UTF8 -jar ${package} nogui
done
