
------------------------����������------------------------------

local encoding = require 'encoding' -- ���������� ���������� ��� ������ � ������� �����������
encoding.default = 'CP1251' -- ����� ��������� �� ���������
local u8 = encoding.UTF8 -- ��� �������� ��� ������ �������� ��������/����� �� ���������
local sampev = require('lib.samp.events')
local request = require('requests')
local imgui = require('mimgui')
local inicfg = require('inicfg')
local faicons = require('fAwesome6')
local ffi = require('ffi')
local json = require('cjson')
------------------------------------------
local tab = 1
--����������--
local gta = ffi.load('GTASA')
local fa = faicons
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
encoding.default = 'cp1251'
local toggled = false
local u8 = encoding.UTF8

--����������  ����--
local ArmyGLmenu, menu = new.bool(), new.bool()
local settingss = new.bool()
local osnovnoe = new.bool()
local zametka = new.bool()
local infom = new.bool()
------------------------------------------------------------------------

local ini = inicfg.load({
    cfg =
    {
mytag = "",
totag = ""
    }}, "Army Helper settings.ini")
    
    local mytag = new.char[255](u8(ini.cfg.mytag))
local totag = new.char[255](u8(ini.cfg.totag))
local zk = "-"

-----------------------API SCRIPT MANAGER-------------------------
EXPORTS = {
  canToggle = function() return true end,
  getToggle = function() return ArmyGLmenu[0] end,
  toggle = function() ArmyGLmenu[0] = not ArmyGLmenu[0] end
}
------------------------------------------------------------------------------------
---------------------------------


function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

--����������--
if not imgui.update then
    imgui.update = {
        needupdate = false, updateText = u8'������� �� \'��������� ����������\'', version = '1.2'
}
end
---------------------------

local namelatin = 0
function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
  for line in text:gmatch('[^\n]+') do
if line:find('���: (.*)') then
    namelatin = line:gsub('{......}', ''):match('���: (.*)')
end
end
end



--����������� ������--
function main()
    while not isSampAvailable() do wait(100) end
     sampRegisterChatCommand('army', function()
         ArmyGLmenu[0] = not ArmyGLmenu[0]
     end)
     sampRegisterChatCommand('mask', mask) 
     sampRegisterChatCommand('bon', body_on) 
     sampRegisterChatCommand('pri', prisaga) 
     sampRegisterChatCommand('d', cmd_d) 
     
     sampRegisterChatCommand('boff', body_off) 
     while true do
        wait(0)
        if lastgun ~= getCurrentCharWeapon(PLAYER_PED) then
            local gun = getCurrentCharWeapon(PLAYER_PED)
            if gun == 3 then
                sampSendChat('/me ������ ������� � �������� ���������')
            elseif gun == 23 then
                sampSendChat('/me ������ ������ � ������, ����� ��������������')
            elseif gun == 24 then
                sampSendChat('/me ������ Desert Eagle � ������, ����� ��������������')
            elseif gun == 25 then
                sampSendChat('/me ������ ����� �� �����, ���� �������� � ����� ��������������')
            elseif gun == 26 then
                sampSendChat('/me ������ ��������� ����� ���, ���� ������� ������ � ���� � ������ ������')
            elseif gun == 28 then
                sampSendChat('/me ������ ��������� ����� ���, ���� ������� ������ � ���� � ������ ���')
            elseif gun == 29 then
                sampSendChat('/me ������ ����� �� �����, ���� ��5 � ����� ��������������')
            elseif gun == 31 then
                sampSendChat('/me ������ ������� �4 �� �����')
            elseif gun == 33 then
                sampSendChat('/me ������ �������� ��� ������� �� ������� �����')
            elseif gun == 34 then
                sampSendChat('/me ������ ����������� �������� � ������� �����')
            elseif gun == 0 then
                sampSendChat('/me �������� ��������������, ����� ������')
            end
            lastgun = gun
        end
    end
end


------------------------------------
--����-



  
imgui.OnFrame(function() return ArmyGLmenu[0] end, function(player)
            local size, res = imgui.ImVec2(600, 400), imgui.ImVec2(getScreenResolution());
        imgui.SetNextWindowSize(size, imgui.Cond.FirstUseEver);
        imgui.SetNextWindowPos(imgui.ImVec2(res.x / 2, res.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5));
        imgui.Begin(u8'Army Helper', ArmyGLmenu, imgui.WindowFlags.NoTitleBar);
imgui.CenterText('Army Helper') 
imgui.SetCursorPosY(30 / 2)
         imgui.Image(logo, imgui.ImVec2(200, 135))
         imgui.SetCursorPosY(160)
         
    if imgui.Button(fa('xmark') .. u8' ', imgui.ImVec2(35, 35)) then  
    ArmyGLmenu[0] = not ArmyGLmenu[0]
	end

     if imgui.Button(fa('user_police') .. u8' ��������', imgui.ImVec2(200, 40)) then tab = 1 end    
	if imgui.Button(fa('gear') .. u8' ���������', imgui.ImVec2(200, 40)) then tab = 2 end
    if imgui.Button(fa('user_police') .. u8' ����� ������������', imgui.ImVec2(200, 40)) then tab = 4 end     
    if imgui.Button(fa('info') .. u8' ����������', imgui.ImVec2(200, 40)) then tab = 3 end     
imgui.SetCursorPos(imgui.ImVec2(215, 33))
if imgui.BeginChild('Name', imgui.ImVec2(-1, -1), true) then


if tab == 1 then  
                       		if imgui.CollapsingHeader(u8'�� ��������') then
                      if imgui.CollapsingHeader(u8'��� �������') then
              if imgui.Button(fa('user_police') .. u8' ������� �����', imgui.ImVec2(215, 29)) then
              lua_thread.create(function()
		sampSendChat('/do �� ����� ����� ����������� �����.')
		wait(1500)
		sampSendChat('/do � ����� ����� � ������������� �..')
		wait(1500)
		sampSendChat('/me ������� ����� �� ����')
		wait(1500)
		sampSendChat('/me ���������� ����� ������� �������� ����')
		wait(1500)
		sampSendChat('/me ������ �� ����� ��������� ��������')
		wait(1500)
		sampSendChat('/me �������� ��� ������ � ������� �� � ����������� �������')
		wait(1500)
		sampSendChat('/me ����������� �������� �����')
		wait(1500)
		sampSendChat('/todo ��� ����, ������� ������ *�������� ��������')
		wait(1500)
		sampSendChat('/me ������ �� ����� � ������������� �������� � ���������-������')
		wait(1500)
		sampSendChat('/me ������� �������� � �������')
		wait(1500)
		sampSendChat('/do ����� 30 ������ �������� ��������.')
		wait(1500)
		sampSendChat('/me ���� ���������� ������� � ���������-������ � ������ ����')
		wait(1500)
		sampSendChat('/me �������� ������� � ����� ������')
		wait(1500)
		sampSendChat('/me ��������� ������� ��������')
		wait(1500)
		sampSendChat('/do ������ 3 �������, �������������� ������ �������')
		wait(1500)
		sampSendChat('/me �������� �������� �� �������')
		wait(1500)
		sampSendChat('/me ������� �������� � ��������� ������� � �����')
		wait(1500)
		sampSendChat('/me ����� ������ ��������� �� �����')
		wait(1500)
		sampSendChat('/do ����� ���������� � ��� �� ������� ���� ������ � ������.')
		wait(1500)
		sampSendChat('/me ������ �� ����������� ������� ��������� � ��������� ������ ������ �������')
		wait(1500)
		sampSendChat('/me ������� �������� � ����� � �������������')
	end)
end
imgui.SameLine()
if imgui.Button(fa('user_police') .. u8' ������� ������� �����', imgui.ImVec2(215, 29)) then
        lua_thread.create(function()
		sampSendChat('/do ������ ������� ����� ��������.')
		wait(1500)
		sampSendChat('/do ����� ����� � �����..')
		wait(1500)
		sampSendChat('/me ������ ��������� �������� �� �������')
		wait(1500)
		sampSendChat('/me �������� ������ ������� �����')
	wait(1500)
		sampSendChat('/me ���������� �����')
		wait(1500)
		sampSendChat('/me �������� �� �� ����� ������')
		wait(1500)
		sampSendChat('������ �����')
		wait(1500)
		sampSendChat('/me �������� ����� �����')
		wait(1500)
		sampSendChat('/me ������� �������� ������� � ������')
		wait(1500)
		sampSendChat('/do �������� � �������.')
		wait(1500)
		sampSendChat('/do ����� ����� ����� �� ����� ������.')
	end)
end
end 
                      
                                            		if imgui.CollapsingHeader(u8'������/�������� ������') then
   if imgui.Button(fa('user_police') .. u8' ������ ��������', imgui.ImVec2(215, 29)) then
   	lua_thread.create(function()
		sampSendChat('/me ����������� ������� ������ �� ��������� ���������')
		wait(1500)
		sampSendChat('/me ����������� ��������� ����� � �������� � ��������� �������')
		wait(1500)
		sampSendChat('/me ����������� ���������� ��������')
		wait(1500)
		sampSendChat('/me ����������� ������ ��������� �������')
		wait(1500)
		sampSendChat('/me ������� ����� � ������� ������ � �������� �� ��������������')
		wait(1500)
		sampSendChat('/me ����������� ������� ������-�����������')
		wait(1500)
		sampSendChat('/me ����������� ������')
		wait(1500)
		sampSendChat('/me ������ ����� � ������ ��������')
		wait(1500)
		sampSendChat('/me ����������� ������� � ��������')
		wait(1500)
		sampSendChat('/me ������� ������� �� ����')
		wait(1500)
		sampSendChat('/do ������� �� �����.')
		sampSendChat('/s ������ ��������')
	end)
end
imgui.SameLine()
   if imgui.Button(fa('user_police') .. u8' �������� ��������', imgui.ImVec2(215, 29)) then
   lua_thread.create(function()
		sampSendChat('/do ������� �� �����.')
		wait(1500)
		sampSendChat('/me ���� ������� � �����')
		wait(1500)
		sampSendChat('/me ������� ������� �� ����')
		wait(1500)
		sampSendChat('/do ������� �� �����.')
		wait(1500)
		sampSendChat('/me �������� �������� ��������')
		wait(1500)
		sampSendChat('/me ������� �������')
		wait(1500)
	sampSendChat('/me ��������, ��� �� ������� � ����������')
		wait(1500)
		sampSendChat('/me ����� ����� � ��������������� �� ������ ��������')
		wait(1500)
		sampSendChat('/me ������� ������')
		wait(1500)
		sampSendChat('/me ������� ������ ��������� �������')
		wait(1500)
		sampSendChat('/me ������� ���������� ��������')
		wait(1500)
		sampSendChat('/me ������� ��������� ����� � ��������')
		wait(1500)
		sampSendChat('/me ������� ������� ������ �� ��������� ���������')
		wait(1500)
		sampSendChat('/s �������� ��������')
	end)
end

if imgui.Button(fa('user_police') .. u8' ������ ���������', imgui.ImVec2(215, 29)) then
   lua_thread.create(function()
		sampSendChat('/me ���� �������� � ������ ����') 
wait(1500)
sampSendChat('/me ���� ��������� ����� ���������� ������� � ����� ������') 
wait(1500)
sampSendChat('/me ������ �� ����� ������') 
wait(1500)
sampSendChat('/me ����������� ������ � �����') 
wait(1500)
sampSendChat('/me ������ �� ����� �������') 
wait(1500)
sampSendChat('/me ������� ������� � ��������� ��������') 
wait(1500)
sampSendChat('/me ������� �������� �� ����') 
wait(1500)
sampSendChat('/me ������ ��������') 
wait(1500)
sampSendChat('/me ���� �������� � ������ ����') 
wait(1500)
sampSendChat('/me ������� �������� � ������')
	end)
end
imgui.SameLine()
if imgui.Button(fa('user_police') .. u8' �������� ���������', imgui.ImVec2(215, 29)) then
   lua_thread.create(function()
		sampSendChat('/do �������� � ������')
wait(1500)
sampSendChat('/me ������ �������� �� ������') 
wait(1500)
sampSendChat('/me ���� �������� � ������ ����') 
wait(1500)
sampSendChat('/me �������� �������� ���������') 
wait(1500)
sampSendChat('/me ���� �������� � ��������������') 
wait(1500)
sampSendChat('/me ������ ������� �� ��������� ��������') 
wait(1500)
sampSendChat('/me ������� ������� �� ����') 
wait(1500)
sampSendChat('/me ������� ��������� �����') 
wait(1500)
sampSendChat('/me ������� ������ �� ��������� �����')
wait(1500)
sampSendChat('/me ������� ������ �� ����') 
wait(1500)
sampSendChat('/me ������� �������� �� ����') 
wait(1500)
sampSendChat('/do �������� �� �����') 
wait(1500)
sampSendChat('/me �������� ��������') 

	end)
end

end 
    end
                                          		if imgui.CollapsingHeader(u8'������') then
                                          if imgui.Button(fa('user_police') .. u8' ����� �����', imgui.ImVec2(215, 29)) then
   lua_thread.create(function()
   sampSendChat('/s ������� �����, ��������� ����� ') 
wait(3500)
sampSendChat('/s ������ � ������� ��� ��� ������ �� ���� ������ ����� ') 
wait(3500)
sampSendChat('/s ������ �������������� ������ �������� �� ����������... ') 
wait(3500)
sampSendChat('/s ...���������� ��� ���� �����, ������� ���������� ���������� ������ ') 
wait(3500)
sampSendChat('/s ����� �� ����� ������������� ��������� � �������� ��������� ') 
wait(3500)
sampSendChat('/s ���� �� ��������� �� ����, �� ������� ������ ������ � ����� � ��������� ����� ������ 10 ����� ') 
wait(3500)
sampSendChat('/s ���� �� ���������� ���-�� ������������� ��������������� �������� � ����� ') 
wait(3500)
sampSendChat('/s ��, � �� ���� ������ �� ���� "����� �����" ������� � �����. ') 
end) 
end
imgui.SameLine()
                                          if imgui.Button(fa('user_police') .. u8' ������������ ', imgui.ImVec2(215, 29)) then
   lua_thread.create(function()
   sampSendChat('/s ������� �����, ��������� �����') 
   wait(3500)
sampSendChat('/s ������ � ������� ��� ������ �� ���� "������������" ') 
wait(3500)
sampSendChat('/s ��������� ����. ������ �������������� ������...') 
wait(3500)
sampSendChat('/s ...��������� � ��������� ������� ������� �� ������') 
wait(3500)
sampSendChat('/s �� ������������ �������, ������� �� ������������ ������� � ������') 
wait(3500)
sampSendChat('/s �������������� �������� �������') 
wait(3500)
sampSendChat('/s ���������� �������������� ���� � ����� ������ ��������� �������') 
wait(3500)
sampSendChat('/s ������ � ������� � ���� ����������� ��� �� ��������� ������...') 
wait(3500)
sampSendChat('/s ...����, � ���� �����������') 
wait(3500)
sampSendChat('/s ��, � �� ���� ������ �� ���� "������������" ��������') 
end) 
end

                                          if imgui.Button(fa('user_police') .. u8' ������� ', imgui.ImVec2(215, 29)) then
   lua_thread.create(function()
sampSendChat('/s ������� �����, ��������� �����') 
wait(3500)
sampSendChat('/s ������ � ������� ��� ��� ������ �� ���� "�������" ') 
wait(3500)
sampSendChat('/s ������ ���� ������ ��������� �� ���������� ������� ����� � ������� �����') 
wait(3500)
sampSendChat('/s ������� ����� � ����������� ����� � 9 ���� �� 21 ������') 
wait(3500)
sampSendChat('/s ���� ���-�� �������� ������������ ����� ��� ����������...') 
wait(3500)
sampSendChat('/s ...����������� �������, �� �������� ������� � ���������� � ������ ����') 
wait(3500)
sampSendChat('/s ����� ������ ��������� �������� ���������� ������� ���� � ������� �����') 
wait(3500)
sampSendChat('/s ������ �������� ��� � ����� - ������������ �����������') 
wait(3500)
sampSendChat('/s ��, � �� ���� ������ �� ���� "�������" ��������. ������� �� ��������') 
      end) 
      end 
      imgui.SameLine()
                                          if imgui.Button(fa('user_police') .. u8' �������������� ����� ', imgui.ImVec2(215, 29)) then
   lua_thread.create(function()      
      sampSendChat('/s ������� �����, ��������� �����') 
wait(3500)
sampSendChat('/s ������ � ������� ��� ��� ������ �� ���� "�������������� �����"') 
wait(3500)
sampSendChat('/s ������ �� ������ �������/������/�������� � �� ������ ��.���������/����������� ���������...') 
wait(3500)
sampSendChat('/s ...�������� ������� ���� ��� ���������� ����������� �������') 
wait(3500)
sampSendChat('/s ���� �� ������ �����������, �� ��������� � ������� �� ������...') 
wait(3500)
sampSendChat('/s ... ���������/������� 3-�� �����/��.����������� � ����') 
wait(3500)
sampSendChat('/s ������ ����� ��� ������������ �� �����, �������� ��� ����� ���������') 
wait(3500)
sampSendChat('/s ����������� ������� ��������� ���������� ��������� �� 20 �����...') 
wait(3500)
sampSendChat('/s ...����������� ��������/��������/���������� ��� ��� ������������') 
wait(3500)
sampSendChat('/s � ��� ���� �������������� �����, � ������� �� ������� �������� ���� ��� �����') 
wait(3500)
sampSendChat('/s � 13:00...') 
wait(3500)
sampSendChat('/s ...�� 14:00') 
wait(3500)
sampSendChat('/s �� ���� ������ �� ���� "�������������� �����" ��������') 
     end) 
     end
     end
     
elseif tab == 2 then  
if imgui.Button(u8'������������� ������') then
          lua_thread.create(function() wait(5) thisScript():reload() end)
      end
      imgui.ShowCursor = false
      if imgui.IsItemHovered() then imgui.SetTooltip(u8'�������� ���, ����� ������������� ������')
      end
      imgui.SameLine()
      if imgui.Button(u8'��������� ������') then
          lua_thread.create(function() wait(1) thisScript():unload() end)
      imgui.ShowCursor = false
      end
          		if imgui.CollapsingHeader(u8'Auto Update') then
      if imgui.update.needupdate then
          local centered_x = (imgui.GetWindowWidth() - imgui.CalcTextSize(u8'����������').x) / 2
          imgui.SetCursorPosX(centered_x)
          if imgui.Button(u8'����������') then
              local response = request.get('https://raw.githubusercontent.com/L1keARZ/Scripta/main/Army%20Helper.lua')
                   if response.status_code == 200 then
                      local file = io.open(thisScript().filename, 'wb')
                         if file then
                             file:write(response.text)
                             file:close()
                             thisScript():reload()
                        else
                            sampAddChatMessage('���, ��������, ������ ������ �������, ��� � ����������', -1)
                       end
                end
          end
      else
          local centered_x = (imgui.GetWindowWidth() - imgui.CalcTextSize(u8'��������� ����������').x) / 2
          imgui.SetCursorPosX(centered_x)
              if imgui.Button(u8'��������� ����������') then
                  local response = request.get('https://raw.githubusercontent.com/L1keARZ/Scripta/main/Test.json')
                      if response.status_code == 200 then
                          local data = json.decode(response.text) -- ������������, ��� ���� ���������� JSON
                              if data and data.version and data.version ~= imgui.update.version then
                                  imgui.update.needupdate = true
                                  imgui.update.updateText = u8'������� ���������� �� ������ ' .. data.version
                                  else
                                  imgui.update.updateText = u8'���������� �� �������'
                              end
                      else
                      imgui.update.updateText = u8'������ ' .. tostring(response.status_code)
                      end
                  end
              end

-- ����������� ������������ �� �����������
  if imgui.update.updateText ~= '' then
      imgui.Separator()
      local updateTextWidth = imgui.CalcTextSize(imgui.update.updateText).x
      local centered_x = (imgui.GetWindowWidth() - updateTextWidth) / 2
      imgui.SetCursorPosX(centered_x)
      imgui.Text(imgui.update.updateText)
      imgui.Separator()
  end
  end
            		if imgui.CollapsingHeader(u8'��������� ���������') then
            end
            
elseif tab == 3 then  
imgui.TextWrapped(fa('keyboard') ..u8' ������������, ������� �� ������������� ������ ������� ���  ������� "Arizona Games" ') 

                      		if imgui.CollapsingHeader(u8'�����') then
                  imgui.TextWrapped(u8'������: @Likearz � @stik_lord [Telegram]')
      imgui.TextWrapped(u8'������ �������: 1.1')
      imgui.TextWrapped(u8'������ �� ���������, ������������ ������� � [Telegram]')
      if imgui.Button(u8' ���� ������ ', imgui.ImVec2(145, 27)) then  
          gta._Z12AND_OpenLinkPKc('https://t.me/Berloga_Arthura_Lotova ')
      end
      end 
                            		if imgui.CollapsingHeader(u8'�������') then
                            imgui.TextWrapped(fa('keyboard') ..u8' 1) /mask - �� ��������� �����')
                            imgui.TextWrapped(fa('keyboard') ..u8' 2) /pri - �������')
                            imgui.TextWrapped(fa('keyboard') ..u8' 3) /bon - �� ��������� ��������� ������')
                            imgui.TextWrapped(fa('keyboard') ..u8' 4) /boff - �� ��������� ���������� ������')
                             
end    

elseif tab == 4 then  

    
    if imgui.Button(u8" �� �����", imgui.ImVec2(195, 29)) then 
    sampSendChat("/d ["..ini.cfg.mytag.."] "..zk.." ["..ini.cfg.totag.."]: �� �����!")
    end
    imgui.SameLine()
    if imgui.Button(u8"�� ����� [ ������ ]" , imgui.ImVec2(195, 29)) then
    sampSendChat("/d ["..ini.cfg.mytag.."] "..zk.." ["..ini.cfg.totag.."]: �� �����! *��������*")
    end
  imgui.SameLine()
    if imgui.Button(u8"����� �����", imgui.ImVec2(195, 29)) then
    sampSendChat("/d ["..ini.cfg.mytag.."] - [����]: ��������, ����� �����!") 
    end
   
    if imgui.Button(u8"����� �����", imgui.ImVec2(195, 29)) then
    sampSendChat("/d ["..ini.cfg.mytag.."] "..zk.." ["..ini.cfg.totag.."]: ����� �����")
    end
    imgui.SameLine()
    if imgui.Button(u8"������ �� �������", imgui.ImVec2(195, 29)) then
    sampSendChat("/d ["..ini.cfg.mytag.."] "..zk.." ["..ini.cfg.totag.."]: ������ �� �������, ����� �����")
    end	    
imgui.SameLine() 
    if imgui.Button(u8"�� � �����", imgui.ImVec2(195, 29)) then
    sampSendChat("/d ["..ini.cfg.mytag.."]  �.� [��]: ���� ������! �� ���� ���� ��������� ���������!")
    end	  
if imgui.Button(u8"�� ���� ������", imgui.ImVec2(195, 29)) then
    sampSendChat("/d ["..ini.cfg.mytag.."]  - [����]: �� ���� ������? ")
    end	     
    
imgui.CenterText(fa('user_police') .. u8' ���������') 
    imgui.InputText(u8"��� ���", mytag, 255)
    ini.cfg.mytag = u8:decode(str(mytag))
    cfg_save()
    
    imgui.InputText(u8"��� ���������", totag, 255)
    ini.cfg.totag = u8:decode(str(totag))
    cfg_save()
    
    if imgui.Button(u8"�������� �����", imgui.ImVec2(215, 29)) then
    zk = "�.�."
    ini.cfg.zk = u8:decode(str(zk))
    end
    
    if imgui.Button(u8"�������� �����", imgui.ImVec2(215, 29)) then
    zk = "-"
    ini.cfg.zk = u8:decode(str(zk))
    end
    
    if zk == "-" then
    imgui.Text(u8"������ �������� �����")
    end
    
    if zk == "�.�." then
    imgui.Text(u8"������ �������� �����") 
    end
    
 end 
imgui.EndChild()
end 
    imgui.End()
end)

function sampev.onSendSpawn()
sampSendChat('/stats') 
sampAddChatMessage('[{FF00FF}Army Helper]: ������������ ', -1)
sampAddChatMessage('[{FF00FF}Army Helper] ��������', -1)
sampAddChatMessage('[{FF00FF}Army Helper]: ���������: /army', -1)
end

function cmd_d(data)
if data == "" then
sampAddChatMessage("������� ��������� ��� ��������!", -1)
else
sampSendChat("/d ["..ini.cfg.mytag.."] "..zk.." ["..ini.cfg.totag.."]: "..data.."")
end
end


function mask()
	lua_thread.create(function()
		sampSendChat('/do �� ������ ����� ����� �����.')
		wait(1500)
		sampSendChat('/me ���� ����� � �����, ���������� ������ �����, � ����� ���������� � � ������� ���������')
		wait(1500)
		sampSendChat('/me ������� �����, ������� ������ �����, ����� ������� � �� �����')
		wait(1500)
		sampSendChat('/me ���������� ������, ������� ������� �� ����� �����')
		wait(1500)
		sampSendChat('/do � ���� ��������� ������� �����.')
		wait(1500)
		sampSendChat('/me ����� �� ������ ���������')
		wait(1500)
		sampSendChat('/mask')
	end)
end 

function body_on()
	lua_thread.create(function()
		sampSendChat('/do �� ����� ����� ������� ���� ������ ���� "FRAPS" .')
		wait(1500)
		sampSendChat('/me ���������� ��������� ���� ������� ���� ������')
		wait(1500)
		sampSendChat('/do ���� ������ �������� � ������ ������')
	end)
end

function body_off()
	lua_thread.create(function()
		sampSendChat('/do �� ����� ����� ������� ���� ������ ���� "FRAPS".')
		wait(1500)
		sampSendChat('/me ���������� ��������� ���� �������� ���� ������')
		wait(1500)
		sampSendChat('/do ���� ������ ��������� � ��������� ������')
	end)
end

function prisaga()
	lua_thread.create(function()
		sampSendChat('/me ����� ������') 
wait(1500)
sampSendChat('/me ������ ������ ����') 
wait(1500)
sampSendChat('/me ��������� ������ �����') 
wait(3500)
sampSendChat('/s �,  ������������ �������� �� �������� ������ �����!') 
wait(3500)
sampSendChat('/s ������� ����� ��������� ��� ������ � �����������!') 
wait(3500)
sampSendChat('/s ������ ��������� ���������� �������� �������, ������� ���������� � �����������!') 
wait(3500)
sampSendChat('/s � ������� �������� ��� ����, ����������� ������ �� ������ ��� ������� � �������������!')
 wait(3500)
sampSendChat('/s ������� ���� ������������, ������ � ���������������!') 
wait(3500)
sampSendChat('/s ������� �������� ��������� c��� �������� ����!') 
wait(3500)
sampSendChat('/s ���� �� � ������ ��� ��� ������������� ������..') 
wait(3500)
sampSendChat('/s ..�� ����� ���� ��������� ������� ��������� ������ � �������� ��������� ������!') 
wait(3500)
sampSendChat('/me �������� ������ ����') 
wait(3500)
sampSendChat('/me ��������� ������') 
	end)
end


imgui.OnInitialize(function()
    getTheme()
end)
function getTheme()
   imgui.SwitchContext()
   --==[ CONFIG ]==--
   local style  = imgui.GetStyle()
   local colors = style.Colors
   local clr    = imgui.Col
   local ImVec4 = imgui.ImVec4
   local ImVec2 = imgui.ImVec2

   --==[ STYLE ]==--
   imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
   imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
   imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
   imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
   imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
   imgui.GetStyle().IndentSpacing = 0
   imgui.GetStyle().ScrollbarSize = 10
   imgui.GetStyle().GrabMinSize = 10

   --==[ BORDER ]==--
   imgui.GetStyle().WindowBorderSize = 1
   imgui.GetStyle().ChildBorderSize = 1
   imgui.GetStyle().PopupBorderSize = 1
   imgui.GetStyle().FrameBorderSize = 1
   imgui.GetStyle().TabBorderSize = 1

   --==[ ROUNDING ]==--
   imgui.GetStyle().WindowRounding = 5
   imgui.GetStyle().ChildRounding = 5
   imgui.GetStyle().FrameRounding = 5
   imgui.GetStyle().PopupRounding = 5
   imgui.GetStyle().ScrollbarRounding = 5
   imgui.GetStyle().GrabRounding = 5
   imgui.GetStyle().TabRounding = 5

   --==[ ALIGN ]==--
   imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
   imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
   imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
   
   --==[ COLORS ]==--
   colors[clr.Text]                 = ImVec4(1.00, 1.00, 1.00, 1.00)
   colors[clr.TextDisabled]         = ImVec4(0.73, 0.75, 0.74, 1.00)
   colors[clr.WindowBg]             = ImVec4(0.09, 0.09, 0.09, 1.00)
   colors[clr.PopupBg]              = ImVec4(0.10, 0.10, 0.10, 1.00) 
   colors[clr.Border]               = ImVec4(0.20, 0.20, 0.20, 0.50)
   colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00)
   colors[clr.FrameBg]              = ImVec4(0.00, 0.39, 1.00, 0.65)
   colors[clr.FrameBgHovered]       = ImVec4(0.11, 0.40, 0.69, 1.00)
   colors[clr.FrameBgActive]        = ImVec4(0.11, 0.40, 0.69, 1.00) 
   colors[clr.TitleBg]              = ImVec4(0.00, 0.00, 0.00, 1.00)
   colors[clr.TitleBgActive]        = ImVec4(0.00, 0.24, 0.54, 1.00)
   colors[clr.TitleBgCollapsed]     = ImVec4(0.00, 0.22, 1.00, 0.67)
   colors[clr.MenuBarBg]            = ImVec4(0.08, 0.44, 1.00, 1.00)
   colors[clr.ScrollbarBg]          = ImVec4(0.02, 0.02, 0.02, 0.53)
   colors[clr.ScrollbarGrab]        = ImVec4(0.31, 0.31, 0.31, 1.00)
   colors[clr.ScrollbarGrabHovered] = ImVec4(0.41, 0.41, 0.41, 1.00)
   colors[clr.ScrollbarGrabActive]  = ImVec4(0.51, 0.51, 0.51, 1.00)
   colors[clr.CheckMark]            = ImVec4(1.00, 1.00, 1.00, 1.00)
   colors[clr.SliderGrab]           = ImVec4(0.34, 0.67, 1.00, 1.00)
   colors[clr.SliderGrabActive]     = ImVec4(0.84, 0.66, 0.66, 1.00)
   colors[clr.Button]               = ImVec4(0.00, 0.39, 1.00, 0.65)
   colors[clr.ButtonHovered]        = ImVec4(0.00, 0.64, 1.00, 0.65)
   colors[clr.ButtonActive]         = ImVec4(0.00, 0.53, 1.00, 0.50)
   colors[clr.Header]               = ImVec4(0.00, 0.62, 1.00, 0.54)
   colors[clr.HeaderHovered]        = ImVec4(0.00, 0.36, 1.00, 0.65)
   colors[clr.HeaderActive]         = ImVec4(0.00, 0.53, 1.00, 0.00)
   colors[clr.Separator]            = ImVec4(0.43, 0.43, 0.50, 0.50)
   colors[clr.SeparatorHovered]     = ImVec4(0.71, 0.39, 0.39, 0.54)
   colors[clr.SeparatorActive]      = ImVec4(0.71, 0.39, 0.39, 0.54)
   colors[clr.ResizeGrip]           = ImVec4(0.71, 0.39, 0.39, 0.54)
   colors[clr.ResizeGripHovered]    = ImVec4(0.84, 0.66, 0.66, 0.66)
   colors[clr.ResizeGripActive]     = ImVec4(0.84, 0.66, 0.66, 0.66)
   colors[clr.PlotLines]            = ImVec4(0.61, 0.61, 0.61, 1.00)
   colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.43, 0.35, 1.00)
   colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00)
   colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
   colors[clr.TextSelectedBg]       = ImVec4(0.26, 0.59, 0.98, 0.35)
end


imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('solid'), 14, config, iconRanges)
    
    	logo = imgui.CreateTextureFromFile(u8(getWorkingDirectory() .. '/Army Helper/logo.png'))
end)

function cfg_save()
inicfg.save(ini, "Army Helper settings.ini")
end

ffi.cdef[[
    void _Z12AND_OpenLinkPKc(const char* link);
]]