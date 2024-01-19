
------------------------Библиотеки-----------------------------

local encoding = require 'encoding' -- подключаем библиотеку для работы с разными кодировками
encoding.default = 'CP1251' -- задаём кодировку по умолчанию
local u8 = encoding.UTF8 -- это позволит нам писать задавать названия/текст на кириллице
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
    sampAddChatMessage("[UxyOy AutoSchool Helper]: {FFFFFF}Скрипт успешно загрузился", 9109759)
    sampAddChatMessage("[UxyOy AutoSchool Helper]: {FFFFFF}Авторы:t.me/UxyOy", 9109759)
    sampAddChatMessage("[UxyOy AutoSchool Helper]: {FFFFFF}Чтобы посмотреть комманды,введите /helper and /helpers", 9109759)
end

--ПЕРЕМЕННЫЕ--
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



--ОБНОВЛЕНИЕ--
if not imgui.update then
    imgui.update = {
        needupdate = false, updateText = u8"Нажмите на \"Проверить обновление\"", version = "1.3.9"
}
end
---------------------------



--регистрация команд--
function main()
    while not isSampAvailable() do wait(100) end
     sampRegisterChatCommand("ob", function()
         WinState[0] = not WinState[0]
     end)
end
------------------------------------



--отрисовка мимгуи
local newframe = (
imgui.OnFrame(function() return WinState[0] end, function(player)
  imgui.SetNextWindowSize(imgui.ImVec2(490, 275))
  imgui.Begin(u8"##AutoSchool Helper", WinState)

------------------------------------------------
  imgui.BeginChild('Button', imgui.ImVec2(120, -1))
--создание кнопок--
  
  if imgui.Button(u8 "Настройки", imgui.ImVec2(118, 28)) then
      CurrentTab = 3
  end
  imgui.EndChild()
---------------------------------
  imgui.SameLine()
  imgui.BeginChild('Tabs', imgui.ImVec2(-1, -1))

  if CurrentTab == 3 then
      
      if imgui.Button(u8"Перезагрузить Скрипт") then
          lua_thread.create(function() wait(5) thisScript():reload() end)
      end
      imgui.ShowCursor = false
      if imgui.IsItemHovered() then imgui.SetTooltip(u8"Кликните ЛКМ, чтобы перезагрузить скрипт")
      end
      imgui.SameLine()
      if imgui.Button(u8"Выгрузить Скрипт") then
          lua_thread.create(function() wait(1) thisScript():unload() end)
      imgui.ShowCursor = false
      end
      
      if imgui.update.needupdate then
          local centered_x = (imgui.GetWindowWidth() - imgui.CalcTextSize(u8"Обновиться").x) / 2
          imgui.SetCursorPosX(centered_x)
          if imgui.Button(u8"Обновиться") then
              local response = request.get("https://raw.githubusercontent.com/L1keARZ/Scripta/main/Obnova.lua")
                   if response.status_code == 200 then
                      local file = io.open(thisScript().filename, "wb")
                         if file then
                             file:write(response.text)
                             file:close()
                             thisScript():reload()
                        else
                            sampAddChatMessage("Упс, ошибочка, сообщи автору скрипта, оно в настройках", -1)
                       end
                end
          end
      else
          local centered_x = (imgui.GetWindowWidth() - imgui.CalcTextSize(u8"Проверить обновление").x) / 2
          imgui.SetCursorPosX(centered_x)
              if imgui.Button(u8"Проверить обновление") then
                  local response = request.get("https://raw.githubusercontent.com/L1keARZ/Scripta/main/Test.json")
                      if response.status_code == 200 then
                          local data = json.decode(response.text) -- Предполагаем, что есть библиотека JSON
                              if data and data.version and data.version ~= imgui.update.version then
                                  imgui.update.needupdate = true
                                  imgui.update.updateText = u8"Найдено обновление на версию " .. data.version
                                  else
                                  imgui.update.updateText = u8"Обновлений не найдено"
                              end
                      else
                      imgui.update.updateText = u8"Ошибка " .. tostring(response.status_code)
                      end
                  end
              end

-- Уведомление пользователя об обновлениях
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
