﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.model.WeaponInfo

package room.model
{
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.WeaponBallManager;

    public class WeaponInfo 
    {

        public static var ROTATITON_SPEED:Number = 1;

        private var _info:ItemTemplateInfo;
        public var armMaxAngle:Number = 90;
        public var armMinAngle:Number = 50;
        public var commonBall:int;
        public var skillBall:int;
        public var skill:int = -1;
        public var actionType:int;
        public var specialSkillMovie:int;
        public var refineryLevel:int;
        public var bombs:Array;

        public function WeaponInfo(_arg_1:ItemTemplateInfo)
        {
            this._info = _arg_1;
            this.armMinAngle = Number(_arg_1.Property5);
            this.armMaxAngle = Number(_arg_1.Property6);
            this.commonBall = Number(_arg_1.Property1);
            this.skillBall = Number(_arg_1.Property2);
            this.actionType = Number(_arg_1.Property3);
            this.skill = int(_arg_1.Property4);
            this.bombs = WeaponBallManager.getWeaponBallInfo(_arg_1.TemplateID);
            if (((this.bombs) && (this.bombs[0])))
            {
                this.commonBall = this.bombs[0];
            };
            this.refineryLevel = int(_arg_1.RefineryLevel);
        }

        public function get TemplateID():int
        {
            return (this._info.TemplateID);
        }

        public function dispose():void
        {
            this._info = null;
        }


    }
}//package room.model

