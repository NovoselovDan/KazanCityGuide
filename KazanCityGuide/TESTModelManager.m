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
    point.coord = CLLocationCoordinate2DMake(55.787389, 49.121610);
    point.title = @"Часы на ул. Баумана";
    point.text = @"Исәнмесез! Рады видть Вас в Казани! Место на котором Вы находитесь называется \"Площадь имени Габдуллы Тукая\" – названа в честь татарского поэта. Сами казанцы называют эту площадь \"Кольцо\" название повелось оттого, что в своё время в этом месте заканчивался маршрут нескольких трамваев и существовали так называемые разворотные кольца. Ныне трамвайных путей уже не существует, но это название сохранилось и отразилось на названии расположенного через дорогу торгового центра. Сейчас площадь является общественным центром города, местом сосредоточения ряда торговых и развлекательных заведений. Например, одно из расположенных рядом зданий (на нём написано ГУМ), как можно догадаться - это торговый центр. Его объем образован объединением нескольких соседних зданий. Но, не смотря на декор их фасадов, только одно из них является историческим. К слову, когда-то в нём располагался один из лучших ресторанов в городе, конкурировавший с другим, мимо которого Вы ещё пройдёте.";
    point.route = route;
    [points addObject:point];
    
//    point = [[RoutePoint alloc] init];
//    point.coord = CLLocationCoordinate2DMake(55.78389, 49.125800);
//    point.title = @"Точка 2";
//    point.text = @"Описание точки №2. Бла-бла-бла...";
//    point.route = route;
//    [points addObject:route];

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
