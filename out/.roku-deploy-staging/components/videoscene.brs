sub init()

    m.video = m.top.findNode("exampleVideo")
    m.video.observeField("focusedChild", "onFocusChain")
    
    m.posterPlay = m.top.findNode("play")
    m.posterPlay.observeField("focusedChild", "onFocusChain")

    m.posterPause = m.top.findNode("pause")
    m.posterPause.observeField("focusedChild", "onFocusChain")

    m.posterFocuse = m.top.findNode("focuse")

    m.progressRod = m.top.findNode("rod")
    m.progressRod.observeField("focusedChild", "onFocusChain")

    m.video.setFocus(true)

    upContent()

end sub

sub upContent()

    m.videocontent = createObject("RoSGNode", "ContentNode")

    m.videocontent.title = "Example Video"
    m.videocontent.streamformat = "mp4"
    m.videocontent.url = "https://image.roku.com/ZHZscHItMTc2/roku-streaming-overview-v3.mp4"

    m.video.content = m.videocontent
    m.video.control = "play"

end sub

sub onFocusChain()
    if  m.video.isInFocusChain() then
        m.progressRod.visible = "false"
        m.posterFocuse.visible = "false"
        m.posterPlay.visible = "false"
        m.posterPause.visible = "false"
    elseif m.posterPlay.isInFocusChain() and m.video.control = "pause" 
        m.posterFocuse.visible = "true"
        m.progressRod.visible = "true"
        m.posterPlay.visible = "true"
        m.posterPause.visible = "false"
    elseif m.posterPause.isInFocusChain() and (m.video.control = "play" or m.video.control = "resume")
        m.posterFocuse.visible = "true"
        m.progressRod.visible = "true"
        m.posterPause.visible = "true"
        m.posterPlay.visible = "false"
    elseif m.progressRod.isInFocusChain() and (m.video.control = "play" or m.video.control = "resume")
        m.posterFocuse.visible = "false"
        m.progressRod.visible = "true"
        m.posterPause.visible = "true"
        m.posterPlay.visible = "false"
    elseif m.progressRod.isInFocusChain() and m.video.control = "pause" 
        m.posterFocuse.visible = "false"
        m.progressRod.visible = "true"
        m.posterPause.visible = "false"
        m.posterPlay.visible = "true"
    end if

end sub

sub onItemSelected()

    if m.posterPlay.isInFocusChain() then
        m.video.control = "resume"
        m.posterPause.setFocus(true) 
    elseif m.posterPause.isInFocusChain() then
        m.video.control = "pause"
        m.posterPlay.setFocus(true)
    end if

end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = true
    ?">>key ";key;">>press ";press
    ?"STATE.VIDEO";m.video.control

    if press then

        if key = "down" then

            if  m.video.isInFocusChain() then
                m.progressRod.setFocus(true)
            elseif m.progressRod.isInFocusChain() and (m.video.control = "play" or m.video.control = "resume")
                m.posterPause.setFocus(true) 
            elseif m.progressRod.isInFocusChain() and m.video.control = "pause"
                m.posterPlay.setFocus(true)
            elseif m.posterPause.isInFocusChain() or m.posterPlay.isInFocusChain()
                m.video.setFocus(true)
            end if

        elseif key = "up" then
            
            if  m.progressRod.isInFocusChain() then
                m.video.setFocus(true)
            elseif m.video.isInFocusChain() and (m.video.control = "play" or m.video.control = "resume")
                m.posterPause.setFocus(true) 
            elseif m.video.isInFocusChain() and m.video.control = "pause"
                m.posterPlay.setFocus(true)
            elseif m.posterPause.isInFocusChain() or m.posterPlay.isInFocusChain()
                m.progressRod.setFocus(true)
            end if
        
        elseif key = "OK" then

            onItemSelected()

        end if
          
    end if

   return handled
end function
