
------------------------����������-----------------------------

local encoding = require 'encoding' -- ���������� ���������� ��� ������ � ������� �����������
encoding.default = 'CP1251' -- ����� ��������� �� ���������
local u8 = encoding.UTF8 -- ��� �������� ��� ������ �������� ��������/����� �� ���������
local sampev = require("lib.samp.events")
local request = require("requests")
local imgui = require("mimgui")
local inicfg = require("inicfg")
local faicons = require("fAwesome6")
local ffi = require("ffi")
local json = require("cjson")
------------------------------------------

function sampev.onSendSpawn()
    sampSendChat("/stats")
    sampAddChatMessage("[UxyOy AutoSchool Helper]: {FFFFFF}������ ������� ����������", 9109759)
    sampAddChatMessage("[UxyOy AutoSchool Helper]: {FFFFFF}������:t.me/UxyOy", 9109759)
    sampAddChatMessage("[UxyOy AutoSchool Helper]: {FFFFFF}����� ���������� ��������,������� /helper and /helpers", 9109759)
end

--����������--
local gta = ffi.load("GTASA")
local CurrentTab = 0
local fa = faicons
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
encoding.default = "cp1251"
local toggled = false
local u8 = encoding.UTF8
local WinState, menu = new.bool(), new.bool()
------------------------------------------------------------------------

------------------------API SCRIPT MANAGER-------------------------
EXPORTS = {
  canToggle = function() return true end,
  getToggle = function() return WinState[0] end,
  toggle = function() WinState[0] = not WinState[0] end
}
-------------------------------------------------------------------------------------



--����������--
if not imgui.update then
    imgui.update = {
        needupdate = false, updateText = u8"������� �� \"��������� ����������\"", version = "1.3.8"
}
end
---------------------------



--����������� ������--
function main()
    while not isSampAvailable() do wait(100) end
     sampRegisterChatCommand("ob", function()
         WinState[0] = not WinState[0]
     end)
end
------------------------------------



--��������� ������
local newframe = (
imgui.OnFrame(function() return WinState[0] end, function(player)
  imgui.SetNextWindowSize(imgui.ImVec2(490, 275))
  imgui.Begin(u8"##AutoSchool Helper", WinState)

------------------------------------------------
  imgui.BeginChild('Button', imgui.ImVec2(120, -1))
--�������� ������--
  
  if imgui.Button(u8 "���������", imgui.ImVec2(118, 28)) then
      CurrentTab = 3
  end
  imgui.EndChild()
---------------------------------
  imgui.SameLine()
  imgui.BeginChild('Tabs', imgui.ImVec2(-1, -1))

  if CurrentTab == 3 then
      
      if imgui.Button(u8"������������� ������") then
          lua_thread.create(function() wait(5) thisScript():reload() end)
      end
      imgui.ShowCursor = false
      if imgui.IsItemHovered() then imgui.SetTooltip(u8"�������� ���, ����� ������������� ������")
      end
      imgui.SameLine()
      if imgui.Button(u8"��������� ������") then
          lua_thread.create(function() wait(1) thisScript():unload() end)
      imgui.ShowCursor = false
      end
      
      if imgui.update.needupdate then
          local centered_x = (imgui.GetWindowWidth() - imgui.CalcTextSize(u8"����������").x) / 2
          imgui.SetCursorPosX(centered_x)
          if imgui.Button(u8"����������") then
              local response = request.get("https://raw.githubusercontent.com/L1keARZ/Scripta/main/Obnova.lua")
                   if response.status_code == 200 then
                      local file = io.open(thisScript().filename, "wb")
                         if file then
                             file:write(response.text)
                             file:close()
                             thisScript():reload()
                        else
                            sampAddChatMessage("���, ��������, ������ ������ �������, ��� � ����������", -1)
                       end
                end
          end
      else
          local centered_x = (imgui.GetWindowWidth() - imgui.CalcTextSize(u8"��������� ����������").x) / 2
          imgui.SetCursorPosX(centered_x)
              if imgui.Button(u8"��������� ����������") then
                  local response = request.get("https://raw.githubusercontent.com/L1keARZ/Scripta/main/Test.json")
                      if response.status_code == 200 then
                          local data = json.decode(response.text) -- ������������, ��� ���� ���������� JSON
                              if data and data.version and data.version ~= imgui.update.version then
                                  imgui.update.needupdate = true
                                  imgui.update.updateText = u8"������� ���������� �� ������ " .. data.version
                                  else
                                  imgui.update.updateText = u8"���������� �� �������"
                              end
                      else
                      imgui.update.updateText = u8"������ " .. tostring(response.status_code)
                      end
                  end
              end

-- ����������� ������������ �� �����������
  if imgui.update.updateText ~= "" then
      imgui.Separator()
      local updateTextWidth = imgui.CalcTextSize(imgui.update.updateText).x
      local centered_x = (imgui.GetWindowWidth() - updateTextWidth) / 2
      imgui.SetCursorPosX(centered_x)
      imgui.Text(imgui.update.updateText)
      imgui.Separator()
  end
--------------------------
  imgui.EndChild()
  imgui.End()
  end
  end)
)
