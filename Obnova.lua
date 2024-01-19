
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
        needupdate = false, updateText = u8"Нажмите на \"Проверить обновление\"", version = "7.7.7"
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
          		if imgui.CollapsingHeader(u8'Auto Update') then

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
  end
--------------------------
  imgui.EndChild()
  imgui.End()
  end
  end)
)

imgui.OnInitialize(function()
    themeExample()
end)
function themeExample()
    imgui.SwitchContext()
    local ImVec4 = imgui.ImVec4
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10
    imgui.GetStyle().WindowBorderSize = 1
    imgui.GetStyle().ChildBorderSize = 1
    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().FrameBorderSize = 1
    imgui.GetStyle().TabBorderSize = 1
    imgui.GetStyle().WindowRounding = 8
    imgui.GetStyle().ChildRounding = 8
    imgui.GetStyle().FrameRounding = 8
    imgui.GetStyle().PopupRounding = 8
    imgui.GetStyle().ScrollbarRounding = 8
    imgui.GetStyle().GrabRounding = 8
    imgui.GetStyle().TabRounding = 8
 
    imgui.GetStyle().Colors[imgui.Col.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    imgui.GetStyle().Colors[imgui.Col.ChildBg]                = ImVec4(1.00, 1.00, 1.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    imgui.GetStyle().Colors[imgui.Col.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67)
    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    imgui.GetStyle().Colors[imgui.Col.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
    imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Separator]              = ImVec4(0.43, 0.43, 0.50, 0.50)
    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
    imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
    imgui.GetStyle().Colors[imgui.Col.Tab]                    = ImVec4(0.98, 0.26, 0.26, 0.40)
    imgui.GetStyle().Colors[imgui.Col.TabHovered]             = ImVec4(0.98, 0.26, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabActive]              = ImVec4(0.98, 0.06, 0.06, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = ImVec4(0.98, 0.26, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = ImVec4(0.98, 0.26, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
end

