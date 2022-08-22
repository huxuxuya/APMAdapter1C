
#Область ПрограммныйИнтерфейс

// Создает структуру, используемую для фиксации событий трассировки.
// 
// Параметры:
//  ИмяСервиса - Строка - Название сервиса - паттерн: ^[a-zA-Z0-9 _-]+$ (Внимание: только латиница!)
// 
// Возвращаемое значение:
//  Структура - Создать событие монторинга:
// * metadata - Структура -: Метаданные для трассировки
// ** system - Структура -: Метаданные системы
// *** platform - Строка - Название платформы системы
// *** hostname - Строка - Имя хостовой машины
// *** architecture - Строка - Архитектура сисемы, на котрой работает система
// ** service - Структура -: Метаданные сервиса, мониторинг которого осуществляется
// *** name - Строка - Имя сервиса 
// *** version - Строка - Версия сервиса
// *** language - Структура -: Язык разработки на котором написан сервис
// **** name - Строка - Название языка разработки
// **** version - Строка - Версия языка разработи
// *** id - Строка - Уникальный идентификатор запущенного сервиса 
// *** agent - Структура -: Информация об агенте выполняющим работу с APM
// **** name - Строка - Имя агента
// **** version - Строка - Версия агента
// ** user - Структура -: Данные пользователя
// *** username - Строка - Имя пользователя
// * transaction - Структура - Описание транзакции, в рамках которой отражаются отрезки
// * spans - Массив - Массив отрезков трассировки
// * response - Неопределено или Структура - Результат выполнения запроса
// ** statusCode - Строка - код состояния ответа, заполняется после отправки данных
// ** body - Строка - тело ответа, заполняется после отправки данных
Функция НовоеСобытиеМонторинга(ИмяСервиса) Экспорт
	
	МетаданныеСобытия = Новый Структура; 	
	МетаданныеСобытия.Вставить("system", СистемнаяИнформация());
	МетаданныеСобытия.Вставить("service", ОписаниеСервиса(ИмяСервиса));
	МетаданныеСобытия.Вставить("user", ОписаниеПользователя());
	
	СтруктураСобытия = Новый Структура;
	СтруктураСобытия.Вставить("metadata", МетаданныеСобытия);
	СтруктураСобытия.Вставить("transaction",);
	СтруктураСобытия.Вставить("spans", Новый Массив);
	СтруктураСобытия.Вставить("response", Неопределено);
	
	Возврат СтруктураСобытия;
	
КонецФункции

// Добавить транзакцию - добавляет транзакцию в событие мониторинга.
// 
// Параметры:
//  Событие - Структура - Событие, инициализированное функцией "НовоеСобытиеМонторинга"
//  НазваниеТранзакции - Строка - Название транзакции в рамках которой будет добавляться отрезки
Процедура ДобавитьТранзакцию(Событие, НазваниеТранзакции, ТипТранзакции = "request") Экспорт
	
	span_count = Новый Структура;
	span_count.Вставить("started", );
	span_count.Вставить("dropped", 0);
	
	ДанныеТранзакции = Новый Структура; 
	ДанныеТранзакции.Вставить("id", СокрЛП(Новый УникальныйИдентификатор()));
	ДанныеТранзакции.Вставить("name", НазваниеТранзакции);
	ДанныеТранзакции.Вставить("type", ТипТранзакции);
	ДанныеТранзакции.Вставить("sampled", Истина);
	ДанныеТранзакции.Вставить("duration", 0);
	ДанныеТранзакции.Вставить("trace_id", СокрЛП(Новый УникальныйИдентификатор));
	ДанныеТранзакции.Вставить("span_count", span_count);
	ДанныеТранзакции.Вставить("outcome",  "success");
	ДанныеТранзакции.Вставить("timestamp", ТекущаяУниверсальнаяДатаВМикросекундахОтЮниксЭпохи());
	
	Событие.transaction = ДанныеТранзакции;
	
КонецПроцедуры

// Закрыть транзакцию - закрывает транзакцию, рассчитывая и устанавливая ее длительность.
// 
// Параметры:
//  Событие - Структура - Событие, инициализированное функцией "НовоеСобытиеМонторинга"
Процедура ЗакрытьТранзакцию(Событие) Экспорт
	
	Транзакция = Событие.transaction;
	Транзакция.duration = (ТекущаяУниверсальнаяДатаВМикросекундахОтЮниксЭпохи() - Транзакция.timestamp) / 1000;
	Транзакция.span_count.started = Событие.spans.Количество();
	
КонецПроцедуры

// Добавить отрезок - добавляет отрезок в рамках транзакции.
// 
// Параметры:
//  Событие - Структура - Событие, инициализированное функцией "НовоеСобытиеМонторинга"
//  НазваниеСобытия - Строка - Название события отрезка
Процедура ДобавитьОтрезок(Событие, НазваниеСобытия) Экспорт
	
	ИдентификаторТранзакции = Событие.transaction.id;
	ИдентификаторТрассировки = Событие.transaction.trace_id;
	
	ДанныеОтрезка = Новый Структура;
	ДанныеОтрезка.Вставить("duration", 100);
	ДанныеОтрезка.Вставить("id", СокрЛП(Новый УникальныйИдентификатор()));
	ДанныеОтрезка.Вставить("name", НазваниеСобытия);
	ДанныеОтрезка.Вставить("start", 0);
	ДанныеОтрезка.Вставить("trace_id", ИдентификаторТрассировки);
	ДанныеОтрезка.Вставить("parent_id", ИдентификаторТранзакции);
	ДанныеОтрезка.Вставить("timestamp", ТекущаяУниверсальнаяДатаВМикросекундахОтЮниксЭпохи());  
	ДанныеОтрезка.Вставить("type", "request");
	ДанныеОтрезка.Вставить("transaction_id", ИдентификаторТранзакции);
	
	ЗакрытьПоследнийОтрезок(Событие);
	
	Событие.spans.Добавить(ДанныеОтрезка); 
	
КонецПроцедуры

// Закрыть последний отрезок - рассчитывает длительность последней транзакции, таким образом, "закрывая" ее.
// 
// Параметры:
//  Событие - Структура - Событие, инициализированное функцией "НовоеСобытиеМонторинга"
Процедура ЗакрытьПоследнийОтрезок(Событие) Экспорт 
	
	КоличествоСобытий = Событие.spans.Количество();
	Если КоличествоСобытий = 0 Тогда
		Возврат
	КонецЕсли; 
	
	ПоследнееСобытие = Событие.spans[КоличествоСобытий-1];
	
	ПоследнееСобытие.start = ПоследнееСобытие.timestamp - Событие.transaction.timestamp; 
	
	ПоследнееСобытие.duration = (ТекущаяУниверсальнаяДатаВМикросекундахОтЮниксЭпохи() - ПоследнееСобытие.timestamp) / 1000;; 
	
КонецПроцедуры

// Отправляет данные трассировки на адрес публикации APM 
// 
// Параметры:
//  Событие - Структура - Событие, инициализированное функцией "НовоеСобытиеМонторинга"
//  Адрес - Строка - Адрес подключения к APM
Процедура ОтправитьДанныеТрассировки(Событие, Адрес) Экспорт
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/x-ndjson");
	
	ЗаголовкиСтруктура = Новый Структура;
	ЗаголовкиСтруктура.Вставить("Заголовки", Заголовки);
	
	ТекстЗапроса = СериализоватьСобытие(Событие);
	
	РезультатОтправкиСообщения = КоннекторHTTP.Post(Адрес, ТекстЗапроса, ЗаголовкиСтруктура);
	ТелоОтвет = КоннекторHTTP.КакТекст(РезультатОтправкиСообщения);
	
	Событие.response = Новый Структура("statusCode, body", РезультатОтправкиСообщения.КодСостояния, ТелоОтвет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция Версия() Экспорт
	
	Возврат "1.0.0.1";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекущаяУниверсальнаяДатаВМикросекундахОтЮниксЭпохи() 
	
	МиллисекундВСекунде = 1000;
	МикросекундВМиллисекунде = 1000;
	СекундДо1970Года = (Дата(1970,1,1,1,0,0) - Дата(01,1,1,1,0,0));
	МиллисекундДоЭпохиЮникс = СекундДо1970Года * МиллисекундВСекунде;
	
	Возврат (ТекущаяУниверсальнаяДатаВМиллисекундах() - МиллисекундДоЭпохиЮникс) * МикросекундВМиллисекунде;
	
КонецФункции

Функция СистемнаяИнформация()
	
	ИнформацияСистемы =  Новый СистемнаяИнформация;  
	
	СистемнаяИнформация = Новый Структура;
	СистемнаяИнформация.Вставить("platform", ИнформацияСистемы.ВерсияОС);
	СистемнаяИнформация.Вставить("hostname", ИмяКомпьютера());  
	СистемнаяИнформация.Вставить("architecture",  СокрЛП(ИнформацияСистемы.ТипПлатформы));
	
	Возврат СистемнаяИнформация;
	
КонецФункции

Функция СериализоватьСобытие(Знач Событие)
	
	МассивДанныхЗапроса = Новый Массив;
	МассивДанныхЗапроса.Добавить(Новый Структура("metadata", Событие.metadata));
	МассивДанныхЗапроса.Добавить(Новый Структура("transaction", Событие.transaction)); 
	Для Каждого Элемент Из Событие.spans Цикл
		МассивДанныхЗапроса.Добавить(Новый Структура("span", Элемент));
	КонецЦикла;
	
	ПараметрыЗаписи = Новый Структура("ПереносСтрок", ПереносСтрокJSON.Нет);
	текст = "";
	Для Каждого Элемент Из МассивДанныхЗапроса Цикл 
		
		текст = текст + КоннекторHTTP.ОбъектВJson(Элемент, ,ПараметрыЗаписи) + Символы.ПС;
		
	КонецЦикла;
	
	Возврат текст;
	
КонецФункции

Функция ОписаниеСервиса(НазваниеСобытия)
	
	ОписаниеСервиса = Новый Структура;
	ОписаниеСервиса.Вставить("name", НазваниеСобытия);
	ОписаниеСервиса.Вставить("version", Метаданные.Версия);
	ОписаниеСервиса.Вставить("language", ЯзыкРазработки());
	ОписаниеСервиса.Вставить("id", СтрокаСоединенияИнформационнойБазы());
	ОписаниеСервиса.Вставить("agent", АгентСобытия());
	
	Возврат ОписаниеСервиса;
	
КонецФункции

Функция ОписаниеПользователя()
	
	ОписаниеПользователя = Новый Структура;
	ОписаниеПользователя.Вставить("username", ПолноеИмяПользователя());
	
	Возврат ОписаниеПользователя;
	
КонецФункции

Функция ЯзыкРазработки()
	
	ИнформацияСистемы =  Новый СистемнаяИнформация;
	
	ЯзыкРазработки = Новый Структура("name, version", "1С", ИнформацияСистемы.ВерсияПриложения); 
	
	Возврат ЯзыкРазработки;
	
КонецФункции

Функция АгентСобытия()
	
	Агент = Новый Структура("name, version", "1С APM Agent", Версия()); 
	
	Возврат Агент;
	
КонецФункции

#КонецОбласти
