// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.Bomb

package game.view
{
    import flash.events.EventDispatcher;
    import ddt.data.BallInfo;
    import game.objects.ActionType;
    import flash.geom.Point;

    public class Bomb extends EventDispatcher 
    {

        public static const FLY_BOMB:int = 3;
        public static const FREEZE_BOMB:int = 1;

        public var Id:int;
        public var X:int;
        public var Y:int;
        public var VX:int;
        public var VY:int;
        public var Actions:Array = new Array();
        public var UsedActions:Array = new Array();
        public var Template:BallInfo;
        public var targetX:Number;
        public var targetY:Number;
        public var damageMod:Number;
        public var changedPartical:String;
        private var i:int = 0;
        public var number:int;
        public var shootCount:int;
        public var IsHole:Boolean;
        public var livingID:int;
        public var isSelf:Boolean;


        private function checkFly(_arg_1:Array, _arg_2:Array):Boolean
        {
            if (int(_arg_1[0]) != int(_arg_2[0]))
            {
                return (true);
            };
            return (false);
        }

        public function get target():Point
        {
            var _local_1:int;
            while (_local_1 < this.Actions.length)
            {
                if (this.Actions[_local_1].type == ActionType.BOMB)
                {
                    return (new Point(this.Actions[_local_1].param1, this.Actions[_local_1].param2));
                };
                if (this.Actions[_local_1].type == ActionType.FLY_OUT)
                {
                    return (new Point(this.Actions[_local_1].param1, this.Actions[_local_1].param2));
                };
                _local_1++;
            };
            var _local_2:int;
            while (_local_2 < this.UsedActions.length)
            {
                if (this.UsedActions[_local_2].type == ActionType.BOMB)
                {
                    return (new Point(this.UsedActions[_local_2].param1, this.UsedActions[_local_2].param2));
                };
                if (this.UsedActions[_local_2].type == ActionType.FLY_OUT)
                {
                    return (new Point(this.UsedActions[_local_2].param1, this.UsedActions[_local_2].param2));
                };
                _local_2++;
            };
            return (null);
        }

        public function get isCritical():Boolean
        {
            var _local_1:int;
            while (_local_1 < this.Actions.length)
            {
                if (this.Actions[_local_1].type == ActionType.BOMBED)
                {
                    return (true);
                };
                _local_1++;
            };
            return (false);
        }


    }
}//package game.view

