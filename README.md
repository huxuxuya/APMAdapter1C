[![Stars](https://img.shields.io/github/stars/huxuxuya/APMAdapter1C.svg?label=Github%20%E2%98%85&a)](https://github.com/huxuxuya/APMAdapter1C/stargazers)
[![Release](https://img.shields.io/github/tag/huxuxuya/APMAdapter1C.svg?label=Last%20release&a)](https://github.com/huxuxuya/APMAdapter1C/releases)

# APMAdapter1C
Адаптер для взаимодействия с Elastic Application Performance Monitoring (APM).

## Возможности
Основные возможности адаптера:
- Создание описания общей транзакции
- Добавление отрезков
- Отправка событий

## Требования
- Платформа **8.3.10** и выше.
- "Коннектор: удобный HTTP-клиент для 1С:Предприятие 8" https://github.com/vbondarevsky/Connector

## Использование
Установите через поставку модуль к себе в конфигурацию(для возможности дальнейшего обновления).

## Пример использования модуля
Как создать транзакцию, добавить два отрезка и отправить данные на сервер:
```bsl
	Событие = Трассировка.НовоеСобытиеМонторинга("Document_PreOrder");	
	Трассировка.ДобавитьТранзакцию(Событие, "Удаление проведения документа", "UnPosting");

	Трассировка.ДобавитьОтрезок(Событие, "Удаление записей");
	Подождать();
	Трассировка.ДобавитьОтрезок(Событие, "Запись");
	Подождать();
	
	Трассировка.ЗакрытьПоследнийОтрезок(Событие);
	Трассировка.ЗакрытьТранзакцию(Событие);
	
	Адрес = "localhost:8200/intake/v2/events";
	Трассировка.ОтправитьДанныеТрассировки(Событие, Адрес);
```

[Документация API, на которой основан данный модуль]( https://www.elastic.co/guide/en/apm/guide/current/api-events.html)

[Быстро посмотреть текст модуля](./APMAdapter1c/src/CommonModules/Трассировка/Module.bsl)
