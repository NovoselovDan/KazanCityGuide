//
//  TESTModelManager.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "TESTModelManager.h"
#import "RoutePoint.h"
#import "RouteFeedback.h"
#import "RouteHintAnnotation.h"

@implementation TESTModelManager

+ (Route *)getRoute {
    Route *route = [[Route alloc] init];
    route.title = @"Прогулка по ул. Баумана";
    route.distance = @"0,9км";
    route.time = @"1,5ч";
    route.rate = @4.5;
    route.text = @"Обзорная экскурсия по центральной улице города. Пройдя её Вы ознакомитесь с рядом достопримечательностей Казани, которые в сумме своей и формируют ту неповторимую атмосферу города.";
    route.image = [UIImage imageNamed:@"TestImage"];
    route.tag = None;
    
    //Route points
    NSMutableArray *points = [NSMutableArray new];
    RoutePoint *point = [[RoutePoint alloc] init];
    point.coord = CLLocationCoordinate2DMake(55.787639, 49.121367);
    point.reachRadius = 20.0;
    point.title = @"Площадь им. Габдуллы Тукая";
    point.text = @"Исәнмесез! Рады видть Вас в Казани! Место на котором Вы находитесь называется \"Площадь имени Габдуллы Тукая\" – названа в честь татарского поэта. Сами казанцы называют эту площадь \"Кольцо\" название повелось оттого, что в своё время в этом месте заканчивался маршрут нескольких трамваев и существовали так называемые разворотные кольца. Ныне трамвайных путей уже не существует, но это название сохранилось и отразилось на названии расположенного через дорогу торгового центра. Сейчас площадь является общественным центром города, местом сосредоточения ряда торговых и развлекательных заведений. Например, одно из расположенных рядом зданий (на нём написано ГУМ), как можно догадаться - это торговый центр. Его объем образован объединением нескольких соседних зданий. Но, не смотря на декор их фасадов, только одно из них является историческим. К слову, когда-то в нём располагался один из лучших ресторанов в городе, конкурировавший с другим, мимо которого Вы ещё пройдёте.";
    point.route = route;
    [points addObject:point];
    
    point = [[RoutePoint alloc] init];
    point.coord = CLLocationCoordinate2DMake(55.787413, 49.121525);
    point.reachRadius = 10.0;
    point.title = @"Часы на ул. Баумана";
    point.text = @"Двигайтесь по пешеходной улице. Это улица Баумана, кстати, пешеходной она стала в 1999 г. Тогда же, в том месте, где улица примыкает к площади, были установлены часы. Эта работа скульптора Игоря Башмакова. Но, создав её, он понял, что композиции недостаёт национального колорита, и обратился за помощью к Наджипу Наккашу – татарскому каллиграфу, принявшихся одним из первых возрождать восточный вид изобразительного искусства – шамаиль – искусство художественной каллиграфии. На циферблате Наджип Наккаш арабским шрифтом написал числительные, а по периметру – строки из стихов Габдуллы Тукая. Присмотритесь к этим символам, сможете прочитать? А хотите? Чтобы узнать их перевод Вам необходимо кое-что сделать...";
    point.route = route;
    
        //Hints
        RouteHintAnnotation *hint = [[RouteHintAnnotation alloc] initWithRoutePoint:point andCoordinate:CLLocationCoordinate2DMake(55.788287, 49.119427)];
        hint.activeRadius = 25.0;
        hint.text = @"Высокая башня из красного кирпича - колокольня Богоявленского собора, но о ней чуть позже.";
        point.hints = [NSArray arrayWithObject:hint];
    
    [points addObject:point];

    route.points = [NSArray arrayWithArray:points];
    
    //Feedbacks
    NSMutableArray *feedbacks = [NSMutableArray new];
    [feedbacks addObject:[[RouteFeedback alloc] initWithName:@"Иван Петров"
                                                        Text:@"Прошли эту экскурсию днём, очень понравилось. Узнали интересную историю этой улицы, посидели в приятной кафешке. Всем советую!"
                                                        Date:@"Вчера"
                                                      Rating:4]];
    [feedbacks addObject:[[RouteFeedback alloc] initWithName:@"Ксения Фомина"
                                                        Text:@"Обстановка в целом нормальная, и расположение хорошее. туалет чистый и приятно заходить. Плюсы закончились. Минусы: официанты исчезают, даже заказ принимают 20 мин ждать нужно. еда не очень, никогда не берите курицу (жаркое) на сковородке, одни кости!!!! приборы убивают, на барахолке что ли откопали))"
                                                        Date:@"4 месяца назад"
                                                      Rating:2]];
    [feedbacks addObject:[[RouteFeedback alloc] initWithName:@"Антон Бла-Бла"
                                                        Text:@"А я упёртый ворчун. Поэтому данный маршрут заслужил максимум 1/5. Всем спасибо, всем пока"
                                                        Date:@"28 июля 2016"
                                                      Rating:1]];
    route.feedbacks = feedbacks;
    
    return route;
}


@end
