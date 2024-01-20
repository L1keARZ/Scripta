
------------------------Библиотеки-----------------------------

local encoding = require 'encoding' -- подключаем библиотеку для работы с разными кодировками
encoding.default = 'CP1251' -- задаём кодировку по умолчанию
local u8 = encoding.UTF8 -- это позволит нам писать задавать названия/текст на кириллице
local sampev = require('lib.samp.events')
local request = require('requests')
local imgui = require('mimgui')
local inicfg = require('inicfg')
local faicons = require('fAwesome6')
local ffi = require('ffi')
local json = require('cjson')
------------------------------------------

function sampev.onSendSpawn()
    sampSendChat('/stats')
    sampAddChatMessage('[ Army Helper]: {FFFFFF}Скрипт успешно загрузился', 9109759)
    sampAddChatMessage('[ Army Helper]: {FFFFFF}Чтобы посмотреть комманды,введите /army', 9109759)
end

--ПЕРЕМЕННЫЕ--
local gta = ffi.load('GTASA')
local CurrentTab = 1
local fa = faicons
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
encoding.default = 'cp1251'
local toggled = false
local u8 = encoding.UTF8
local ArmyGLmenu, menu = new.bool(), new.bool()
------------------------------------------------------------------------

------------------------API SCRIPT MANAGER-------------------------
EXPORTS = {
  canToggle = function() return true end,
  getToggle = function() return ArmyGLmenu[0] end,
  toggle = function() ArmyGLmenu[0] = not ArmyGLmenu[0] end
}
-------------------------------------------------------------------------------------



--ОБНОВЛЕНИЕ--
if not imgui.update then
    imgui.update = {
        needupdate = false, updateText = u8'Нажмите на \'Проверить обновление\'', version = '1.0'
}
end
---------------------------



--регистрация команд--
function main()
    while not isSampAvailable() do wait(100) end
     sampRegisterChatCommand('army', function()
         ArmyGLmenu[0] = not ArmyGLmenu[0]
     end)
     sampRegisterChatCommand('mask', cmd_mask) 
     sampRegisterChatCommand('bon', body_on) 
     sampRegisterChatCommand('boff', body_off) 
     while true do
        wait(0)
        if lastgun ~= getCurrentCharWeapon(PLAYER_PED) then
            local gun = getCurrentCharWeapon(PLAYER_PED)
            if gun == 3 then
                sampSendChat("/me достал дубинку с поясного держателя")
            elseif gun == 23 then
                sampSendChat("/me достал тайзер с кобуры, убрал предохранитель")
            elseif gun == 24 then
                sampSendChat("/me достал Desert Eagle с кобуры, убрал предохранитель")
            elseif gun == 25 then
                sampSendChat("/me достал чехол со спины, взял дробовик и убрал предохранитель")
            elseif gun == 26 then
                sampSendChat("/me резким движением обоих рук, снял военный рюкзак с плеч и достал Обрезы")
            elseif gun == 28 then
                sampSendChat("/me резким движением обоих рук, снял военный рюкзак с плеч и достал УЗИ")
            elseif gun == 29 then
                sampSendChat("/me достал чехол со спины, взял МП5 и убрал предохранитель")
            elseif gun == 31 then
                sampSendChat("/me достал карабин М4 со спины")
            elseif gun == 33 then
                sampSendChat("/me достал винтовку без прицела из военной сумки")
            elseif gun == 34 then
                sampSendChat("/me достал Снайперскую винтовку с военной сумки")
            elseif gun == 0 then
                sampSendChat("/me поставил предохранитель, убрал оружие")
            end
            lastgun = gun
        end
    end
end


------------------------------------


imgui.OnFrame(function() return ArmyGLmenu[0] end, function(player)
            local size, res = imgui.ImVec2(650, 300), imgui.ImVec2(getScreenResolution());
        imgui.SetNextWindowSize(size, imgui.Cond.FirstUseEver);
        imgui.SetNextWindowPos(imgui.ImVec2(res.x / 2, res.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5));
        imgui.Begin(u8'Army Helper', ArmyGLmenu);
 
    if imgui.Button(fa('user_police') .. u8' Основное', imgui.ImVec2(145, 35)) then tab = 1 end -- это первая кнопка, которая будет отвечать за переключение на раздел 1
    imgui.Text('') 
	if imgui.Button(fa('gear') .. u8' Настройки', imgui.ImVec2(145, 35)) then tab = 2 end -- это вторая кнопка, которая будет отвечать за переключение на раздел 2 
	imgui.Text('') 
    if imgui.Button(fa('info') .. u8' Информация', imgui.ImVec2(145, 35)) then  tab = 3 end -- это вторая кнопка, которая будет отвечать за переключение на раздел 2 
    
    imgui.SetCursorPos(imgui.ImVec2(155, 33))
if imgui.BeginChild('Name', imgui.ImVec2(-1, -1), true) then
        
        
    if tab == 1 then
                      		if imgui.CollapsingHeader(u8'Рп ситуации') then
                      if imgui.CollapsingHeader(u8'Для отчётов') then
              if imgui.Button(fa('user_police') .. u8' Починка рации', imgui.ImVec2(-1, 35)) then
              lua_thread.create(function()
		sampSendChat("/do На столе лежит неисправная рация.")
		wait(1500)
		sampSendChat("/do В руках сумка с инструментами у..")
		wait(1500)
		sampSendChat("/me положил сумку на стол")
		wait(1500)
		sampSendChat("/me перевернул рацию лицевой стороной вниз")
		wait(1500)
		sampSendChat("/me достал из сумки крестовую отвертку")
		wait(1500)
		sampSendChat("/me открутил все шурупы и положил их в специальную баночку")
		wait(1500)
		sampSendChat("/me внимательно осмотрел плату")
		wait(1500)
		sampSendChat("/todo Все ясно, контакт отошел *радостно улыбаясь")
		wait(1500)
		sampSendChat("/me достал из сумки с инструментами паяльник и проволоку-припой")
		wait(1500)
		sampSendChat("/me воткнул паяльник в розетку")
		wait(1500)
		sampSendChat("/do Через 30 секунд паяльник нагрелся.")
		wait(1500)
		sampSendChat("/me взял оторванный контакт и проволоку-припой в правую руку")
		wait(1500)
		sampSendChat("/me приложил контакт в место отрыва")
		wait(1500)
		sampSendChat("/me расплавил кусочек проволки")
		wait(1500)
		sampSendChat("/do Спустя 3 секунды, расплавившаяся лужица застыла")
		wait(1500)
		sampSendChat("/me выключил паяльник из розетки")
		wait(1500)
		sampSendChat("/me положил паяльник и проволоку обратно в сумку")
		wait(1500)
		sampSendChat("/me нажал кнопку включения на рации")
		wait(1500)
		sampSendChat("/do Рация включилась и все ее функции были готовы к работе.")
		wait(1500)
		sampSendChat("/me достал из специальной баночки шурупчики и прикрутил заднюю крышку обратно")
		wait(1500)
		sampSendChat("/me положил отвертку в сумку с инструментами")
	end)
end
if imgui.Button(fa('user_police') .. u8' Починка дверной ручки', imgui.ImVec2(-1, 35)) then
        lua_thread.create(function()
		sampSendChat("/do Старая дверная ручка треснута.")
		wait(1500)
		sampSendChat("/do Новая ручка в руках..")
		wait(1500)
		sampSendChat("/me достал маленькую отвертку из кармана")
		wait(1500)
		sampSendChat("/me открутил старую дверную ручку")
	wait(1500)
		sampSendChat("/me распечатал новую")
		wait(1500)
		sampSendChat("/me примерил ее на месте старой")
		wait(1500)
		sampSendChat("Хорошо вошла")
		wait(1500)
		sampSendChat("/me закрутил новую ручку")
		wait(1500)
		sampSendChat("/me положил отвертку обратно в карман")
		wait(1500)
		sampSendChat("/do Отвертка в кармане.")
		wait(1500)
		sampSendChat("/do Новая ручка стоит на месте старой.")
	end)
end
end 
                      
                                            		if imgui.CollapsingHeader(u8'Сборка/разборка оружия') then
   if imgui.Button(fa('user_police') .. u8' Сборка автомата', imgui.ImVec2(-1, 35)) then
   	lua_thread.create(function()
		sampSendChat("/me присоединил газовую трубку со ствольной накладкой")
		wait(1500)
		sampSendChat("/me присоединил затворную рамку с затвором к ствольной коробке")
		wait(1500)
		sampSendChat("/me присоединил возвратный механизм")
		wait(1500)
		sampSendChat("/me присоединил крышку ствольной коробки")
		wait(1500)
		sampSendChat("/me спустил курок с боевого взвода и поставил на предохранитель")
		wait(1500)
		sampSendChat("/me присоединил дульный тормоз-компенсатор")
		wait(1500)
		sampSendChat("/me присоединил шомпол")
		wait(1500)
		sampSendChat("/me вложил пенал в гнездо приклада")
		wait(1500)
		sampSendChat("/me присоединил магазин к автомату")
		wait(1500)
		sampSendChat("/me положил автомат на стол")
		wait(1500)
		sampSendChat("/do Автомат на столе.")
		sampSendChat("/s Сборку завершил")
	end)
end
   if imgui.Button(fa('user_police') .. u8' Разборка автомата', imgui.ImVec2(-1, 35)) then
   lua_thread.create(function()
		sampSendChat("/do Автомат на плече.")
		wait(1500)
		sampSendChat("/me снял автомат с плеча")
		wait(1500)
		sampSendChat("/me положил автомат на стол")
		wait(1500)
		sampSendChat("/do Автомат на столе.")
		wait(1500)
		sampSendChat("/me начинает разборку автомата")
		wait(1500)
		sampSendChat("/me отделил магазин")
		wait(1500)
	sampSendChat("/me проверил, нет ли патрона в патроннике")
		wait(1500)
		sampSendChat("/me вынул пенал с принадлежностью из гнезда приклада")
		wait(1500)
		sampSendChat("/me отделил шомпол")
		wait(1500)
		sampSendChat("/me отделил крышку ствольной коробки")
		wait(1500)
		sampSendChat("/me отделил возвратный механизм")
		wait(1500)
		sampSendChat("/me отделил затворную рамку с затвором")
		wait(1500)
		sampSendChat("/me отделил газовую трубку со ствольной накладкой")
		wait(1500)
		sampSendChat("/s Разборку завершил")
	end)
end
end 
    end
    end 
    
if tab == 3 then
imgui.TextWrapped(fa('keyboard') ..u8' Здравствуйте, спасибо за использование нашего скрипта для семей проекта "Arizona Games" ') 
imgui.Text('') 
                      		if imgui.CollapsingHeader(u8'Автор') then
                  imgui.TextWrapped(u8'Автор: @stik_lord [Telegram]')
      imgui.TextWrapped(u8'Версия скрипта: 1.0.0')
      imgui.TextWrapped(u8'Писать по проблемам, предложениям мне в [Telegram]')
      if imgui.Button(u8' Написать розрабу ') then
          gta._Z12AND_OpenLinkPKc('https://t.me/stik_lord')
      end
      end 
                            		if imgui.CollapsingHeader(u8'Команды') then
                            imgui.TextWrapped(fa('keyboard') ..u8'1) /mask - Рп отыгровка маски')
                            imgui.TextWrapped(fa('keyboard') ..u8'2) /bon - Рп отыгровка включения камеры')
                            imgui.TextWrapped(fa('keyboard') ..u8'2) /boff - Рп отыгровка выключения камеры')
                            end 
end    

if tab == 2 then
                if imgui.Button(u8'Перезагрузить Скрипт') then
          lua_thread.create(function() wait(5) thisScript():reload() end)
      end
      imgui.ShowCursor = false
      if imgui.IsItemHovered() then imgui.SetTooltip(u8'Кликните ЛКМ, чтобы перезагрузить скрипт')
      end
      imgui.SameLine()
      if imgui.Button(u8'Выгрузить Скрипт') then
          lua_thread.create(function() wait(1) thisScript():unload() end)
      imgui.ShowCursor = false
      end
          		if imgui.CollapsingHeader(u8'Auto Update') then
          imgui.Text('Version 1.0')

      if imgui.update.needupdate then
          local centered_x = (imgui.GetWindowWidth() - imgui.CalcTextSize(u8'Обновиться').x) / 2
          imgui.SetCursorPosX(centered_x)
          if imgui.Button(u8'Обновиться') then
              local response = request.get('https://raw.githubusercontent.com/L1keARZ/Scripta/main/Obnova.lua')
                   if response.status_code == 200 then
                      local file = io.open(thisScript().filename, 'wb')
                         if file then
                             file:write(response.text)
                             file:close()
                             thisScript():reload()
                        else
                            sampAddChatMessage('Упс, ошибочка, сообщи автору скрипта, оно в настройках', -1)
                       end
                end
          end
      else
          local centered_x = (imgui.GetWindowWidth() - imgui.CalcTextSize(u8'Проверить обновление').x) / 2
          imgui.SetCursorPosX(centered_x)
              if imgui.Button(u8'Проверить обновление') then
                  local response = request.get('https://raw.githubusercontent.com/L1keARZ/Scripta/main/Test.json')
                      if response.status_code == 200 then
                          local data = json.decode(response.text) -- Предполагаем, что есть библиотека JSON
                              if data and data.version and data.version ~= imgui.update.version then
                                  imgui.update.needupdate = true
                                  imgui.update.updateText = u8'Найдено обновление на версию ' .. data.version
                                  else
                                  imgui.update.updateText = u8'Обновлений не найдено'
                              end
                      else
                      imgui.update.updateText = u8'Ошибка ' .. tostring(response.status_code)
                      end
                  end
              end

-- Уведомление пользователя об обновлениях
  if imgui.update.updateText ~= '' then
      imgui.Separator()
      local updateTextWidth = imgui.CalcTextSize(imgui.update.updateText).x
      local centered_x = (imgui.GetWindowWidth() - updateTextWidth) / 2
      imgui.SetCursorPosX(centered_x)
      imgui.Text(imgui.update.updateText)
      imgui.Separator()
  end
  end 
end 
	    imgui.EndChild() -- обязательно следите за тем, чтобы каждый чайлд был закрыт
end -- это чайлд закрываеться
    imgui.End()
end)

function mask()
	lua_thread.create(function()
		sampSendChat("/do На правом плече висит сумка.")
		wait(1500)
		sampSendChat("/me снял сумку с плеча, расстегнул молнию сумки, и начал обшаривать её в поисках балаклавы")
		wait(1500)
		sampSendChat("/me обшарив сумку, нащупал тонкую ткань, затем вытщаил её из сумки")
		wait(1500)
		sampSendChat("/me расстегнул молнию, положил обратно на плечо сумку")
		wait(1500)
		sampSendChat("/do В руке балаклава чёрного цвета.")
		wait(1500)
		sampSendChat("/me надел на голову балаклаву")
		sampSendChat("/mask")
	end)
end 

function body_on()
	lua_thread.create(function()
		sampSendChat("/do На груди висит скрытая боди камера типа ''FRAPS''.")
		wait(1500)
		sampSendChat("/me незаметным движением руки включил боди камеру")
		wait(1500)
		sampSendChat("/do Боди камера включена и начала съёмку")
	end)
end

function body_off()
	lua_thread.create(function()
		sampSendChat("/do На груди висит скрытая боди камера типа ''FRAPS''.")
		wait(1500)
		sampSendChat("/me незаметным движением руки выключил боди камеру")
		wait(1500)
		sampSendChat("/do Боди камера выключена и закончила съёмку")
	end)
end


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

imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('solid'), 14, config, iconRanges)
end)



ffi.cdef[[
    void _Z12AND_OpenLinkPKc(const char* link);
]]