:- ['cmpefarm.pro'].
:- init_from_map.



%First Predicate: Find the manhattan distance of twp agents.
agents_distance(Agent1, Agent2, Distance) :-
    get_dict(x,Agent1,X1),
    get_dict(y,Agent1,Y1),
    get_dict(x,Agent2,X2),
    get_dict(y,Agent2,Y2),
    Distance is abs(X1-X2)+abs(Y1-Y2).


%My list length predicate
length_finder([], 0).

length_finder([_ | Tail], Length) :-
        length_finder(Tail, TailLength),
        Length is TailLength + 1.

%Second Predicate: Finds the total number of agents in a State and unifies it with NumberOfAgents
number_of_agents(State, NumberOfAgents) :-
        State = [Agents, _, _, _],
        dict_pairs(Agents, _, Pairs),
        length_finder(Pairs, NumberOfAgents).
    
%My gnth0 predicate
my_nth0(0, [X|_], X) :- !.
my_nth0(N, [_|Xs], X) :-
        N > 0,
        N1 is N - 1,
        my_nth0(N1, Xs, X).
    

valueM(cow, 500).
valueM(chicken, 100).
valueM(corn, 10).
valueM(grain, 30).
valueM(grass, 20).
valueM(wolf,0).

%Third Predicate: Calculates the total value of all products on the farm. First I calculate the length of the list with my lenght predicate then I do a recursive loop and find the total value. 

value_of_farm(State, Value) :-
    State=[Agents,Objects, _, _],
    dict_pairs(Agents, _, AgentList),
    length_finder(AgentList,LengthOfAgentList), 
    RealLengthAgent is LengthOfAgentList -1,
    get_all_values_of_list(RealLengthAgent,AgentTotal,AgentList),
    dict_pairs(Objects,_, ObjectList),
    length_finder(ObjectList,LengthOfObjectList), 
    RealLengthObjects is LengthOfObjectList -1,
    get_all_values_of_list(RealLengthObjects,ObjectTotal,ObjectList),
    Value is ObjectTotal + AgentTotal.


get_all_values_of_list(-1,Val,[]):-
    Val is 0. 

get_all_values_of_list(0,Val,AgentList) :-
    valueM(AgentList.0.subtype,Val).

get_all_values_of_list(N,M,AgentList):-
    N>0,
    N1 is N-1,
    get_all_values_of_list(N1,M1,AgentList),
    valueM(AgentList.N.subtype,Temp),
    M is Temp + M1.



can_eatM(cow, grass, 1).
can_eatM(cow, grain, 1).
can_eatM(cow, corn, 0).
can_eatM(cow, wolf, 0).
can_eatM(cow, cow, 0).
can_eatM(cow, chicken, 0).

can_eatM(chicken, grain, 1).
can_eatM(chicken, corn, 1).
can_eatM(chicken, grass, 0).
can_eatM(chicken, wolf, 0).
can_eatM(chicken, cow, 0).
can_eatM(chicken, chicken, 0).

can_eatM(wolf, grain, 0).
can_eatM(wolf, corn, 0).
can_eatM(wolf, grass, 0).
can_eatM(wolf, wolf, 0).
can_eatM(wolf, cow, 1).
can_eatM(wolf, chicken, 1).

get_the_type_of_agent(wolf ,1).
get_the_type_of_agent(cow ,0).
get_the_type_of_agent(chicken ,0).

%Fourth Predicate: Find the coordinates of the foods consumable by the specific Agent at the given State and unifies
%the list of coordinates with Coordinates. First I calculate the length of the list with my lenght predicate then I do a recursive loop and find the total value. 

find_food_coordinates(State, AgentId, Res) :-
    State = [Agents, Objects, _, _],
    get_dict(AgentId, Agents, Agent),
    dict_pairs(Agents, _, AgentList),
    dict_pairs(Objects, _, ObjectList),
    length_finder(ObjectList, LengthOfObjectList), 
    RealLengthObjects is LengthOfObjectList - 1,

    length_finder(AgentList, LengthOfAgentList), 
    RealLengthAgents is LengthOfAgentList - 1,

    get_the_type_of_agent(Agent.subtype, ResType),
    ( ResType > 0 
        -> get_all_coords_of_list(Agent, RealLengthAgents, Res, AgentList) 
        ; get_all_coords_of_list(Agent, RealLengthObjects, Res, ObjectList)
    ),
    \+ Res = []. 


get_all_coords_of_list(Agent, 0,Val,ObjectList) :-
    can_eatM(Agent.subtype,ObjectList.0.subtype, Result),
    (   Result > 0 
    ->   Val = [[ObjectList.0.x, ObjectList.0.y]]
    ;   Val = []
    ).
    
get_all_coords_of_list(Agent, N,M,ObjectList):-
        N>0,
        N1 is N-1,
        get_all_coords_of_list(Agent, N1,M1,ObjectList),
        can_eatM(Agent.subtype,ObjectList.N.subtype, Result),
        (   Result > 0 
        ->   M = [[ObjectList.N.x, ObjectList.N.y] | M1]
        ;   M = M1
        ).


%My predicates for sorting the lists
compare_pairs(<, [_, X1], [_, X2]) :-
    X1 < X2.
compare_pairs(>, [_, X1], [_, X2]) :-
    X1 > X2.
compare_pairs(=, _, _). 

sort_pairs(List, Sorted) :-
    sort_by_compare(compare_pairs, List, Sorted).


sort_by_compare(_, [], []).

sort_by_compare(Pred, [X | Xs], Sorted) :-
    sort_by_compare(Pred, Xs, SortedTail),
    insert_sorted(Pred, X, SortedTail, Sorted).

insert_sorted(_, X, [], [X]).
insert_sorted(Pred, X, [Y | Ys], [X, Y | Ys]) :-
    call(Pred, <, X, Y).
insert_sorted(Pred, X, [Y | Ys], [Y | SortedTail]) :-
    call(Pred, >, X, Y),
    insert_sorted(Pred, X, Ys, SortedTail).


distance(X1, Y1, X2, Y2, Distance) :-
    Distance is abs(X1 - X2) + abs(Y1 - Y2).


%Fifth Predicate: Finds the nearest agent and unifies the agent’s coordinate with Coorinates in the [X,Y] form, and
%unifies the agent’s dictionary with NearestAgent.. First I calculate the length of the list with my lenght predicate then I do a recursive loop and find the total value. 

find_nearest_agent(State, AgentId, Coordinates, NearestAgent) :-
    State = [Agents, _, _, _],
    get_dict(AgentId, Agents, Agent),
    dict_pairs(Agents, _, AgentList),
    length_finder(AgentList, LengthOfAgentList), 
    RealLengthAgents is LengthOfAgentList - 1,
    get_all_distances_of_list(Agent,RealLengthAgents, CoordinatesTemp ,AgentList ),
    sort_pairs(CoordinatesTemp,CoordinatesTempNew),
    CoordinatesTempNew = [ [_,_], [IndexOfNearest,_] | _ ],
    my_nth0(IndexOfNearest, AgentList, NearestAgent),
    Coordinates = [AgentList.IndexOfNearest.x,AgentList.IndexOfNearest.y].
    
get_all_distances_of_list(Agent, 0,Val, AgentList) :-
        distance(Agent.x, Agent.y, AgentList.0.x, AgentList.0.y , Dist),
        Val = [[0,Dist]].

get_all_distances_of_list(Agent, N,M , AgentList):-
            N>0,
            N1 is N-1,
            get_all_distances_of_list(Agent, N1,M1 , AgentList),
            distance(Agent.x,Agent.y, AgentList.N.x, AgentList.N.y , Dist),
            M = [[N, Dist] | M1].
    

        
%Sixth Predicate: e finds the nearest consumable food by the Agent and unifies the object’s coordinate with Coorinates
%in the [X,Y] form, unifies the kind of the food with FoodType, and unifies the Manhattan distance between the food
%and the agent with Distance. . First I calculate the length of the list with my lenght predicate then I do a recursive loop and find the total value. 

find_nearest_food(State, AgentId, Coordinates, FoodType, Distance) :-
    State = [Agents, Objects, _, _],
    get_dict(AgentId, Agents, Agent),
    find_food_coordinates(State,AgentId,TempCoordinates),
    length_finder(TempCoordinates,LengthTempCoordinate),
    RealTempCoordinateLenght is LengthTempCoordinate-1,
 
    make_manhattan_list(Agent,TempCoordinates,RealTempCoordinateLenght,ManhattanCoordinates),

    sort_pairs(ManhattanCoordinates,SortedManhattanCoordinates),
    SortedManhattanCoordinates = [[IndexOfNearest,Distance] |_],
    my_nth0(IndexOfNearest,TempCoordinates,Coordinates),

    my_nth0(0,Coordinates,XCoord),
    my_nth0(1,Coordinates,YCoord),
    get_the_type_of_agent(Agent.subtype, ResType),
    ( ResType > 0 
        -> get_agent_from_positionM(XCoord,YCoord,Agents,Hunted) 
        ; get_object_from_positionM(XCoord,YCoord,Objects,Hunted)
    ),
    FoodType = Hunted.subtype.


make_manhattan_list(Agent, TempCoordinates ,0 , Val) :-
        my_nth0(0,TempCoordinates,Curr),
        my_nth0(0,Curr,XCoord),
        my_nth0(1,Curr,YCoord),

        distance(Agent.x, Agent.y, XCoord, YCoord , Dist),
        Val = [[0,Dist]].

make_manhattan_list(Agent, TempCoordinates, N, M ):-
            N>0,
            N1 is N-1,
            make_manhattan_list(Agent, TempCoordinates, N1, M1 ),
            my_nth0(N,TempCoordinates,Curr),
            my_nth0(0,Curr,XCoord),
            my_nth0(1,Curr,YCoord),

            distance(Agent.x,Agent.y, XCoord, YCoord , Dist),
            M = [[N, Dist] | M1].


get_agent_from_positionM(X, Y, Agents, Agent) :-
        get_dict(_, Agents, Agent),
        get_dict(x, Agent, X), get_dict(y, Agent, Y),!.


get_object_from_positionM(X, Y, Agents, Agent) :-
        get_dict(_, Agents, Agent),
        get_dict(x, Agent, X), get_dict(y, Agent, Y),!.






