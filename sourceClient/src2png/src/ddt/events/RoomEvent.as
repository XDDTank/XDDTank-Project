﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.RoomEvent

package ddt.events
{
    import flash.events.Event;

    public class RoomEvent extends Event 
    {

        public static const CHANGED:String = "changed";
        public static const ROOMPLACE_CHANGED:String = "roomplaceChanged";
        public static const PLAYER_STATE_CHANGED:String = "playerStateChanged";
        public static const WAITGAMEFAILED:String = "waitgamefailed";
        public static const WAITGAMERECV:String = "waitgamerecv";
        public static const WAITGAMECANCEL:String = "waitgamecancel";
        public static const GAME_MODE_CHANGE:String = "gameModeChange";
        public static const WAITSEC30:String = "waitSec30";
        public static const LOADING_PROGRESS:String = "loadingProgress";
        public static const TEAM_CHANGE:String = "";
        public static const HOST_LEAVE:String = "Hostleave";
        public static const ALLOW_CROSS_CHANGE:String = "allowCrossChange";
        public static const MAP_CHANGED:String = "mapChanged";
        public static const ADD_PLAYER:String = "addPlayer";
        public static const REMOVE_PLAYER:String = "removePlayer";
        public static const STARTED_CHANGED:String = "startedChanged";
        public static const OPEN_DUNGEON_CHOOSER:String = "openDungeonChooser";
        public static const MAP_TIME_CHANGED:String = "mapTimeChanged";
        public static const HARD_LEVEL_CHANGED:String = "hardLevelChanged";
        public static const PLACE_COUNT_CHANGED:String = "placeCountChanged";
        public static const TWEENTY_SEC:String = "tweentySec";
        public static const TURNCOUNT_CHANGED:String = "turncountChanged";
        public static const ROOM_NAME_CHANGED:String = "roomNameChanged";
        public static const ROOM_PASS_CHANGED:String = "roomPassChanged";
        public static const OPEN_BOSS_CHANGED:String = "openBossChange";
        public static const VIEWER_ITEM_INFO_SET:String = "viewerItemInfoSet";

        private var _params:Array;

        public function RoomEvent(_arg_1:String, ... _args)
        {
            super(_arg_1);
            this._params = _args;
        }

        public function get params():Array
        {
            return (this._params);
        }


    }
}//package ddt.events

