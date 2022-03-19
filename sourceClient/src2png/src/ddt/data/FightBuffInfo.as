// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.FightBuffInfo

package ddt.data
{
    import ddt.manager.LanguageMgr;
    import calendar.CalendarManager;
    import game.model.GameInfo;
    import game.GameManager;
    import com.pickgliss.loader.ModuleLoader;
    import game.model.Living;

    public class FightBuffInfo 
    {

        public static const DEFUALT_EFFECT:String = "asset.game.AttackEffect2";

        public var id:int;
        public var displayid:int = 0;
        public var type:int;
        private var _sigh:int = -1;
        public var buffPic:String = "";
        public var buffEffect:String = "";
        public var buffName:String = "FightBuffInfo";
        public var description:String = "unkown buff";
        public var priority:Number = 0;
        private var _data:int;
        private var _level:int;
        public var Count:int = 1;
        public var isSelf:Boolean;

        public function FightBuffInfo(_arg_1:int)
        {
            this.id = _arg_1;
            if (BuffType.isLuckyBuff(_arg_1))
            {
                this.buffName = LanguageMgr.GetTranslation("tank.game.BuffNameLucky", ((CalendarManager.getInstance().luckyNum >= 0) ? CalendarManager.getInstance().luckyNum : ""));
            }
            else
            {
                this.buffName = LanguageMgr.GetTranslation(("tank.game.BuffName" + this.id));
            };
        }

        public function get data():int
        {
            return (this._data);
        }

        public function set data(_arg_1:int):void
        {
            var _local_2:GameInfo;
            this._data = _arg_1;
            this.description = LanguageMgr.GetTranslation(("tank.game.BuffTip" + this.id), this._data);
            if (((((this.id == 243) || (this.id == 244)) || (this.id == 245)) || (this.id == 246)))
            {
                _local_2 = GameManager.Instance.Current;
                if (((((_local_2.mapIndex == 1214) || (_local_2.mapIndex == 1215)) || (_local_2.mapIndex == 1216)) || (_local_2.mapIndex == 1217)))
                {
                    this.description = LanguageMgr.GetTranslation((("tank.game.BuffTip" + this.id) + "1"), this._data);
                };
            }
            else
            {
                if (this.id == BuffInfo.MILITARY_BLOOD_BUFF1)
                {
                    this.description = LanguageMgr.GetTranslation("tank.game.BuffTip14", _arg_1);
                };
            };
        }

        public function execute(_arg_1:Living):void
        {
            if (this.type == BuffType.PET_BUFF)
            {
                if (this.buffEffect)
                {
                    if (ModuleLoader.hasDefinition(("asset.game.skill.effect." + this.buffEffect)))
                    {
                        _arg_1.showBuffEffect(("asset.game.skill.effect." + this.buffEffect), this.id);
                    }
                    else
                    {
                        _arg_1.showBuffEffect(DEFUALT_EFFECT, this.id);
                    };
                };
            }
            else
            {
                switch (this.id)
                {
                    case BuffType.LockAngel:
                        _arg_1.isLockAngle = true;
                        return;
                };
            };
        }

        public function unExecute(_arg_1:Living):void
        {
            if (this.type == BuffType.PET_BUFF)
            {
                if (this.buffEffect)
                {
                    _arg_1.removeBuffEffect(this.id);
                };
            }
            else
            {
                switch (this.id)
                {
                    case BuffType.LockAngel:
                        _arg_1.isLockAngle = false;
                        return;
                };
            };
        }


    }
}//package ddt.data

