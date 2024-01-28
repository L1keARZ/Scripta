
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
local tab = 1
--ПЕРЕМЕННЫЕ--
local gta = ffi.load('GTASA')
local fa = faicons
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
encoding.default = 'cp1251'
local toggled = false
local u8 = encoding.UTF8

--ПЕРЕМЕННЫЕ  ОКОН--
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

--ОБНОВЛЕНИЕ--
if not imgui.update then
    imgui.update = {
        needupdate = false, updateText = u8'Нажмите на \'Проверить обновление\'', version = '1.2'
}
end
---------------------------

local namelatin = 0
function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
  for line in text:gmatch('[^\n]+') do
if line:find('Имя: (.*)') then
    namelatin = line:gsub('{......}', ''):match('Имя: (.*)')
end
end
end



--регистрация команд--
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
                sampSendChat('/me достал дубинку с поясного держателя')
            elseif gun == 23 then
                sampSendChat('/me достал тайзер с кобуры, убрал предохранитель')
            elseif gun == 24 then
                sampSendChat('/me достал Desert Eagle с кобуры, убрал предохранитель')
            elseif gun == 25 then
                sampSendChat('/me достал чехол со спины, взял дробовик и убрал предохранитель')
            elseif gun == 26 then
                sampSendChat('/me резким движением обоих рук, снял военный рюкзак с плеч и достал Обрезы')
            elseif gun == 28 then
                sampSendChat('/me резким движением обоих рук, снял военный рюкзак с плеч и достал УЗИ')
            elseif gun == 29 then
                sampSendChat('/me достал чехол со спины, взял МП5 и убрал предохранитель')
            elseif gun == 31 then
                sampSendChat('/me достал карабин М4 со спины')
            elseif gun == 33 then
                sampSendChat('/me достал винтовку без прицела из военной сумки')
            elseif gun == 34 then
                sampSendChat('/me достал Снайперскую винтовку с военной сумки')
            elseif gun == 0 then
                sampSendChat('/me поставил предохранитель, убрал оружие')
            end
            lastgun = gun
        end
    end
end


------------------------------------
--ОКНА-



  
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

     if imgui.Button(fa('user_police') .. u8' Основное', imgui.ImVec2(200, 40)) then tab = 1 end    
	if imgui.Button(fa('gear') .. u8' Настройки', imgui.ImVec2(200, 40)) then tab = 2 end
    if imgui.Button(fa('user_police') .. u8' Рация Департамента', imgui.ImVec2(200, 40)) then tab = 4 end     
    if imgui.Button(fa('info') .. u8' Информация', imgui.ImVec2(200, 40)) then tab = 3 end     
imgui.SetCursorPos(imgui.ImVec2(215, 33))
if imgui.BeginChild('Name', imgui.ImVec2(-1, -1), true) then


if tab == 1 then  
                       		if imgui.CollapsingHeader(u8'Рп ситуации') then
                      if imgui.CollapsingHeader(u8'Для отчётов') then
              if imgui.Button(fa('user_police') .. u8' Починка рации', imgui.ImVec2(215, 29)) then
              lua_thread.create(function()
		sampSendChat('/do На столе лежит неисправная рация.')
		wait(1500)
		sampSendChat('/do В руках сумка с инструментами у..')
		wait(1500)
		sampSendChat('/me положил сумку на стол')
		wait(1500)
		sampSendChat('/me перевернул рацию лицевой стороной вниз')
		wait(1500)
		sampSendChat('/me достал из сумки крестовую отвертку')
		wait(1500)
		sampSendChat('/me открутил все шурупы и положил их в специальную баночку')
		wait(1500)
		sampSendChat('/me внимательно осмотрел плату')
		wait(1500)
		sampSendChat('/todo Все ясно, контакт отошел *радостно улыбаясь')
		wait(1500)
		sampSendChat('/me достал из сумки с инструментами паяльник и проволоку-припой')
		wait(1500)
		sampSendChat('/me воткнул паяльник в розетку')
		wait(1500)
		sampSendChat('/do Через 30 секунд паяльник нагрелся.')
		wait(1500)
		sampSendChat('/me взял оторванный контакт и проволоку-припой в правую руку')
		wait(1500)
		sampSendChat('/me приложил контакт в место отрыва')
		wait(1500)
		sampSendChat('/me расплавил кусочек проволки')
		wait(1500)
		sampSendChat('/do Спустя 3 секунды, расплавившаяся лужица застыла')
		wait(1500)
		sampSendChat('/me выключил паяльник из розетки')
		wait(1500)
		sampSendChat('/me положил паяльник и проволоку обратно в сумку')
		wait(1500)
		sampSendChat('/me нажал кнопку включения на рации')
		wait(1500)
		sampSendChat('/do Рация включилась и все ее функции были готовы к работе.')
		wait(1500)
		sampSendChat('/me достал из специальной баночки шурупчики и прикрутил заднюю крышку обратно')
		wait(1500)
		sampSendChat('/me положил отвертку в сумку с инструментами')
	end)
end
imgui.SameLine()
if imgui.Button(fa('user_police') .. u8' Починка дверной ручки', imgui.ImVec2(215, 29)) then
        lua_thread.create(function()
		sampSendChat('/do Старая дверная ручка треснута.')
		wait(1500)
		sampSendChat('/do Новая ручка в руках..')
		wait(1500)
		sampSendChat('/me достал маленькую отвертку из кармана')
		wait(1500)
		sampSendChat('/me открутил старую дверную ручку')
	wait(1500)
		sampSendChat('/me распечатал новую')
		wait(1500)
		sampSendChat('/me примерил ее на месте старой')
		wait(1500)
		sampSendChat('Хорошо вошла')
		wait(1500)
		sampSendChat('/me закрутил новую ручку')
		wait(1500)
		sampSendChat('/me положил отвертку обратно в карман')
		wait(1500)
		sampSendChat('/do Отвертка в кармане.')
		wait(1500)
		sampSendChat('/do Новая ручка стоит на месте старой.')
	end)
end
end 
                      
                                            		if imgui.CollapsingHeader(u8'Сборка/разборка оружия') then
   if imgui.Button(fa('user_police') .. u8' Сборка автомата', imgui.ImVec2(215, 29)) then
   	lua_thread.create(function()
		sampSendChat('/me присоединил газовую трубку со ствольной накладкой')
		wait(1500)
		sampSendChat('/me присоединил затворную рамку с затвором к ствольной коробке')
		wait(1500)
		sampSendChat('/me присоединил возвратный механизм')
		wait(1500)
		sampSendChat('/me присоединил крышку ствольной коробки')
		wait(1500)
		sampSendChat('/me спустил курок с боевого взвода и поставил на предохранитель')
		wait(1500)
		sampSendChat('/me присоединил дульный тормоз-компенсатор')
		wait(1500)
		sampSendChat('/me присоединил шомпол')
		wait(1500)
		sampSendChat('/me вложил пенал в гнездо приклада')
		wait(1500)
		sampSendChat('/me присоединил магазин к автомату')
		wait(1500)
		sampSendChat('/me положил автомат на стол')
		wait(1500)
		sampSendChat('/do Автомат на столе.')
		sampSendChat('/s Сборку завершил')
	end)
end
imgui.SameLine()
   if imgui.Button(fa('user_police') .. u8' Разборка автомата', imgui.ImVec2(215, 29)) then
   lua_thread.create(function()
		sampSendChat('/do Автомат на плече.')
		wait(1500)
		sampSendChat('/me снял автомат с плеча')
		wait(1500)
		sampSendChat('/me положил автомат на стол')
		wait(1500)
		sampSendChat('/do Автомат на столе.')
		wait(1500)
		sampSendChat('/me начинает разборку автомата')
		wait(1500)
		sampSendChat('/me отделил магазин')
		wait(1500)
	sampSendChat('/me проверил, нет ли патрона в патроннике')
		wait(1500)
		sampSendChat('/me вынул пенал с принадлежностью из гнезда приклада')
		wait(1500)
		sampSendChat('/me отделил шомпол')
		wait(1500)
		sampSendChat('/me отделил крышку ствольной коробки')
		wait(1500)
		sampSendChat('/me отделил возвратный механизм')
		wait(1500)
		sampSendChat('/me отделил затворную рамку с затвором')
		wait(1500)
		sampSendChat('/me отделил газовую трубку со ствольной накладкой')
		wait(1500)
		sampSendChat('/s Разборку завершил')
	end)
end

if imgui.Button(fa('user_police') .. u8' Сборка пистолета', imgui.ImVec2(215, 29)) then
   lua_thread.create(function()
		sampSendChat('/me взял пистолет в правую руку') 
wait(1500)
sampSendChat('/me ввел свободный конец возвратной пружины в канал ствола') 
wait(1500)
sampSendChat('/me поднял со стола затвор') 
wait(1500)
sampSendChat('/me присоединил затвор к рамке') 
wait(1500)
sampSendChat('/me поднял со стола магазин') 
wait(1500)
sampSendChat('/me вставил магазин в основание рукоятки') 
wait(1500)
sampSendChat('/me положил пистолет на стол') 
wait(1500)
sampSendChat('/me сборку завершил') 
wait(1500)
sampSendChat('/me взял пистолет в правую руку') 
wait(1500)
sampSendChat('/me положил пистолет в кобуру')
	end)
end
imgui.SameLine()
if imgui.Button(fa('user_police') .. u8' Разборка пистолета', imgui.ImVec2(215, 29)) then
   lua_thread.create(function()
		sampSendChat('/do Пистолет в кобуре')
wait(1500)
sampSendChat('/me достал пистолет из кобуры') 
wait(1500)
sampSendChat('/me взял пистолет в правую руку') 
wait(1500)
sampSendChat('/me начинает разборку пистолета') 
wait(1500)
sampSendChat('/me снял пистолет с предохранителя') 
wait(1500)
sampSendChat('/me извлек магазин из основания рукоятки') 
wait(1500)
sampSendChat('/me положил магазин на стол') 
wait(1500)
sampSendChat('/me оттянул спусковую скобу') 
wait(1500)
sampSendChat('/me отделил затвор от затворной рамки')
wait(1500)
sampSendChat('/me положил затвор на стол') 
wait(1500)
sampSendChat('/me положил пистолет на стол') 
wait(1500)
sampSendChat('/do Пистолет на столе') 
wait(1500)
sampSendChat('/me разборку завершил') 

	end)
end

end 
    end
                                          		if imgui.CollapsingHeader(u8'Лекции') then
                                          if imgui.Button(fa('user_police') .. u8' Посты Армии', imgui.ImVec2(215, 29)) then
   lua_thread.create(function()
   sampSendChat('/s Здравия желаю, уважаемые бойцы ') 
wait(3500)
sampSendChat('/s Сейчас я проведу для вас лекцию на тему “Посты армии” ') 
wait(3500)
sampSendChat('/s Каждый военнослужащий обязан дежурить на специально... ') 
wait(3500)
sampSendChat('/s ...отведенным для него посту, который определяет офицерский состав ') 
wait(3500)
sampSendChat('/s Спать на посту категорически запрещено и карается выговором ') 
wait(3500)
sampSendChat('/s Если вы заступили на пост, то обязаны делать доклад в рацию о состоянии поста каждые 10 минут ') 
wait(3500)
sampSendChat('/s Если вы обнаружили что-то подозрительно незамедлительно сообщите в рацию ') 
wait(3500)
sampSendChat('/s Ну, а на этом лекция на тему "Посты Армии" подошла к концу. ') 
end) 
end
imgui.SameLine()
                                          if imgui.Button(fa('user_police') .. u8' Субординация ', imgui.ImVec2(215, 29)) then
   lua_thread.create(function()
   sampSendChat('/s Здравия желаю, уважаемые бойцы') 
   wait(3500)
sampSendChat('/s Сейчас я зачитаю Вам лекцию на тему "Субординация" ') 
wait(3500)
sampSendChat('/s Запомните одно. Каждый военнослужащий должен...') 
wait(3500)
sampSendChat('/s ...выполнять и исполнять приказы старших по званию') 
wait(3500)
sampSendChat('/s За невыполнение приказа, который не противоречит законам и уставу…') 
wait(3500)
sampSendChat('/s Военнослужащий получает выговор') 
wait(3500)
sampSendChat('/s Обращаться военнослужащие друг к другу должны следующим образом') 
wait(3500)
sampSendChat('/s Звание и Фамилия к кому обращаетесь или же уважаемый звание...') 
wait(3500)
sampSendChat('/s ...того, к кому обращаетесь') 
wait(3500)
sampSendChat('/s Ну, а на этом лекция на тему "Субординация" окончена') 
end) 
end

                                          if imgui.Button(fa('user_police') .. u8' Самовол ', imgui.ImVec2(215, 29)) then
   lua_thread.create(function()
sampSendChat('/s Здравия желаю, уважаемые бойцы') 
wait(3500)
sampSendChat('/s Сейчас я зачитаю для вас лекцию на тему "Самовол" ') 
wait(3500)
sampSendChat('/s Каждый боец обязан находится на территории военной части в рабочее время') 
wait(3500)
sampSendChat('/s Рабочее время у сотрудников армии с 9 утра до 21 вечера') 
wait(3500)
sampSendChat('/s Если кто-то покидает расположение части без разрешения...') 
wait(3500)
sampSendChat('/s ...офицерского состава, он получает выговор с занесением в личное дело') 
wait(3500)
sampSendChat('/s Также строго запрещено покидать территорию военной базы в рабочей форме') 
wait(3500)
sampSendChat('/s Прогул рабочего дня в форме - наказывается увольнением') 
wait(3500)
sampSendChat('/s Ну, а на этом лекция на тему "Самовол" окончена. Спасибо за внимание') 
      end) 
      end 
      imgui.SameLine()
                                          if imgui.Button(fa('user_police') .. u8' Увольнительное время ', imgui.ImVec2(215, 29)) then
   lua_thread.create(function()      
      sampSendChat('/s Здравия желаю, уважаемые бойцы') 
wait(3500)
sampSendChat('/s Сейчас я зачитаю для вас лекцию на тему "Увольнительное время"') 
wait(3500)
sampSendChat('/s Бойцам со звания рядовой/матрос/охранник и до звания Мл.Лейтенант/Надзиратель запрещено...') 
wait(3500)
sampSendChat('/s ...покидать военную базу без разрешения офицерского состава') 
wait(3500)
sampSendChat('/s Если Вы хотите отпроситься, то подойдите к офицеру от звания...') 
wait(3500)
sampSendChat('/s ... Лейтенант/Капитан 3-го ранга/Ст.Надзиратель и выше') 
wait(3500)
sampSendChat('/s Офицер будет вас сопровождать до места, которого вам нужно добраться') 
wait(3500)
sampSendChat('/s Офицерскому составу разрешено отлучаться ежедневно на 20 минут...') 
wait(3500)
sampSendChat('/s ...предупредив Генерала/Адмирала/Начальника или его заместителей') 
wait(3500)
sampSendChat('/s У вас есть увольнительное время, в которое вы сможете покинуть базу без формы') 
wait(3500)
sampSendChat('/s с 13:00...') 
wait(3500)
sampSendChat('/s ...до 14:00') 
wait(3500)
sampSendChat('/s На этом лекция на тему "Увольнительное время" окончена') 
     end) 
     end
     end
     
elseif tab == 2 then  
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
      if imgui.update.needupdate then
          local centered_x = (imgui.GetWindowWidth() - imgui.CalcTextSize(u8'Обновиться').x) / 2
          imgui.SetCursorPosX(centered_x)
          if imgui.Button(u8'Обновиться') then
              local response = request.get('https://raw.githubusercontent.com/L1keARZ/Scripta/main/Army%20Helper.lua')
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
            		if imgui.CollapsingHeader(u8'Настройка персонажа') then
            end
            
elseif tab == 3 then  
imgui.TextWrapped(fa('keyboard') ..u8' Здравствуйте, спасибо за использование нашего скрипта для  проекта "Arizona Games" ') 

                      		if imgui.CollapsingHeader(u8'Автор') then
                  imgui.TextWrapped(u8'Авторы: @Likearz и @stik_lord [Telegram]')
      imgui.TextWrapped(u8'Версия скрипта: 1.1')
      imgui.TextWrapped(u8'Писать по проблемам, предложениям авторам в [Telegram]')
      if imgui.Button(u8' Наша группа ', imgui.ImVec2(145, 27)) then  
          gta._Z12AND_OpenLinkPKc('https://t.me/Berloga_Arthura_Lotova ')
      end
      end 
                            		if imgui.CollapsingHeader(u8'Команды') then
                            imgui.TextWrapped(fa('keyboard') ..u8' 1) /mask - Рп отыгровка маски')
                            imgui.TextWrapped(fa('keyboard') ..u8' 2) /pri - Присяга')
                            imgui.TextWrapped(fa('keyboard') ..u8' 3) /bon - Рп отыгровка включения камеры')
                            imgui.TextWrapped(fa('keyboard') ..u8' 4) /boff - Рп отыгровка выключения камеры')
                             
end    

elseif tab == 4 then  

    
    if imgui.Button(u8" На связь", imgui.ImVec2(195, 29)) then 
    sampSendChat("/d ["..ini.cfg.mytag.."] "..zk.." ["..ini.cfg.totag.."]: На связь!")
    end
    imgui.SameLine()
    if imgui.Button(u8"На связь [ Повтор ]" , imgui.ImVec2(195, 29)) then
    sampSendChat("/d ["..ini.cfg.mytag.."] "..zk.." ["..ini.cfg.totag.."]: На связь! *Повторяя*")
    end
  imgui.SameLine()
    if imgui.Button(u8"Упала рация", imgui.ImVec2(195, 29)) then
    sampSendChat("/d ["..ini.cfg.mytag.."] - [Всем]: Извините, рация упала!") 
    end
   
    if imgui.Button(u8"Конец связи", imgui.ImVec2(195, 29)) then
    sampSendChat("/d ["..ini.cfg.mytag.."] "..zk.." ["..ini.cfg.totag.."]: Конец связи")
    end
    imgui.SameLine()
    if imgui.Button(u8"Ответа не услышал", imgui.ImVec2(195, 29)) then
    sampSendChat("/d ["..ini.cfg.mytag.."] "..zk.." ["..ini.cfg.totag.."]: Ответа не услышал, конец связи")
    end	    
imgui.SameLine() 
    if imgui.Button(u8"ЧС в армии", imgui.ImVec2(195, 29)) then
    sampSendChat("/d ["..ini.cfg.mytag.."]  з.к [МЮ]: Всем постам! На нашу базу совершено нападение!")
    end	  
if imgui.Button(u8"От кого помехи", imgui.ImVec2(195, 29)) then
    sampSendChat("/d ["..ini.cfg.mytag.."]  - [Всем]: От кого помехи? ")
    end	     
    
imgui.CenterText(fa('user_police') .. u8' Настройки') 
    imgui.InputText(u8"Ваш тег", mytag, 255)
    ini.cfg.mytag = u8:decode(str(mytag))
    cfg_save()
    
    imgui.InputText(u8"Тег обращения", totag, 255)
    ini.cfg.totag = u8:decode(str(totag))
    cfg_save()
    
    if imgui.Button(u8"Закрытый канал", imgui.ImVec2(215, 29)) then
    zk = "з.к."
    ini.cfg.zk = u8:decode(str(zk))
    end
    
    if imgui.Button(u8"Открытый канал", imgui.ImVec2(215, 29)) then
    zk = "-"
    ini.cfg.zk = u8:decode(str(zk))
    end
    
    if zk == "-" then
    imgui.Text(u8"Выбран открытый канал")
    end
    
    if zk == "з.к." then
    imgui.Text(u8"Выбран закрытый канал") 
    end
    
 end 
imgui.EndChild()
end 
    imgui.End()
end)

function sampev.onSendSpawn()
sampSendChat('/stats') 
sampAddChatMessage('[{FF00FF}Army Helper]: Здравствуйте ', -1)
sampAddChatMessage('[{FF00FF}Army Helper] Загружен', -1)
sampAddChatMessage('[{FF00FF}Army Helper]: Активация: /army', -1)
end

function cmd_d(data)
if data == "" then
sampAddChatMessage("Введите сообщение для отправки!", -1)
else
sampSendChat("/d ["..ini.cfg.mytag.."] "..zk.." ["..ini.cfg.totag.."]: "..data.."")
end
end


function mask()
	lua_thread.create(function()
		sampSendChat('/do На правом плече висит сумка.')
		wait(1500)
		sampSendChat('/me снял сумку с плеча, расстегнул молнию сумки, и начал обшаривать её в поисках балаклавы')
		wait(1500)
		sampSendChat('/me обшарив сумку, нащупал тонкую ткань, затем вытщаил её из сумки')
		wait(1500)
		sampSendChat('/me расстегнул молнию, положил обратно на плечо сумку')
		wait(1500)
		sampSendChat('/do В руке балаклава чёрного цвета.')
		wait(1500)
		sampSendChat('/me надел на голову балаклаву')
		wait(1500)
		sampSendChat('/mask')
	end)
end 

function body_on()
	lua_thread.create(function()
		sampSendChat('/do На груди висит скрытая боди камера типа "FRAPS" .')
		wait(1500)
		sampSendChat('/me незаметным движением руки включил боди камеру')
		wait(1500)
		sampSendChat('/do Боди камера включена и начала съёмку')
	end)
end

function body_off()
	lua_thread.create(function()
		sampSendChat('/do На груди висит скрытая боди камера типа "FRAPS".')
		wait(1500)
		sampSendChat('/me незаметным движением руки выключил боди камеру')
		wait(1500)
		sampSendChat('/do Боди камера выключена и закончила съёмку')
	end)
end

function prisaga()
	lua_thread.create(function()
		sampSendChat('/me встал смирно') 
wait(1500)
sampSendChat('/me поднял правую руку') 
wait(1500)
sampSendChat('/me приподнял голову вверх') 
wait(3500)
sampSendChat('/s Я,  торжественно присягаю на верность своему штату!') 
wait(3500)
sampSendChat('/s Клянусь свято соблюдать его законы и конституцию!') 
wait(3500)
sampSendChat('/s Строго выполнять требования воинских уставов, приказы командиров и начальников!') 
wait(3500)
sampSendChat('/s Я клянусь защищать наш штат, непреклонно стоять на страже его свободы и независимости!')
 wait(3500)
sampSendChat('/s Клянусь быть мужественным, верным и самоотверженным!') 
wait(3500)
sampSendChat('/s Клянусь достойно выполнять cвой воинский долг!') 
wait(3500)
sampSendChat('/s Если же я нарушу эту мою торжественную клятву..') 
wait(3500)
sampSendChat('/s ..То пусть меня постигнет суровое наказание закона и всеобщее презрение народа!') 
wait(3500)
sampSendChat('/me отпустил правую руку') 
wait(3500)
sampSendChat('/me расслабил голову') 
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