FlyBtn.MouseButton1Click:Connect(function()
    print("Clique no botão Fly recebido")
    local fspeed = tonumber(FlySpeedBox.Text)
    if fspeed and fspeed > 0 then
        flySpeed = fspeed
        print("Fly Speed definido para", flySpeed)
    else
        print("Fly Speed inválido, mantendo:", flySpeed)
    end

    flying = not flying
    print("Toggle flying para", flying)
    FlyBtn.Text = flying and "Desativar Fly" or "Ativar Fly"
    print("Texto do botão atualizado para:", FlyBtn.Text)

    UpBtn.Visible = flying
    DownBtn.Visible = flying

    if flying then
        print("Chamando startFly()")
        local status, err = pcall(startFly)
        if not status then
            print("Erro ao iniciar fly:", err)
        else
            print("Fly ativado com sucesso")
        end
    else
        print("Chamando stopFly()")
        local status, err = pcall(stopFly)
        if not status then
            print("Erro ao parar fly:", err)
        else
            print("Fly desativado com sucesso")
        end
    end
end)
