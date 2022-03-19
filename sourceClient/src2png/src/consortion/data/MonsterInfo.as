// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.data.MonsterInfo

package consortion.data
{
    import flash.events.EventDispatcher;
    import flash.geom.Point;
    import consortion.event.ConsortionMonsterEvent;

    public class MonsterInfo extends EventDispatcher 
    {

        public static const MONSTER_STATE:String = "MonsterState";
        public static const LIVIN:int = 0;
        public static const DEAD:int = 2;
        public static const FIGHTING:int = 1;

        public var ActionMovieName:String = "game.living.Living082";
        public var ID:int;
        public var MonsterName:String = ("奥古拉斯" + int((Math.random() * 50)));
        public var MissionID:int;
        private var _state:int;
        public var MonsterPos:Point;


        public function get State():int
        {
            return (this._state);
        }

        public function set State(_arg_1:int):void
        {
            if (this._state != _arg_1)
            {
                this._state = _arg_1;
                dispatchEvent(new ConsortionMonsterEvent(ConsortionMonsterEvent.UPDATE_MONSTER_STATE, this._state));
            };
        }


    }
}//package consortion.data

