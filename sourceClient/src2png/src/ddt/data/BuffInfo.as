// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.BuffInfo

package ddt.data
{
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.TimeManager;
    import ddt.manager.ItemManager;

    public class BuffInfo 
    {

        public static const FREE:int = 15;
        public static const DOUBEL_EXP:int = 13;
        public static const DOUBLE_GESTE:int = 12;
        public static const PREVENT_KICK:int = 100;
        public static const MORE_ENETY:int = 102;
        public static const Caddy_Good:int = 70;
        public static const Save_Life:int = 51;
        public static const Agility:int = 50;
        public static const ReHealth:int = 52;
        public static const Train_Good:int = 71;
        public static const Level_Try:int = 101;
        public static const Card_Get:int = 73;
        public static const GemMaster:int = 82;
        public static const Pay_Buff:int = 16;
        public static const ADD_BOMB_MINE_COUNT:int = 200;
        public static const ADD_TRUCK_SPEED:int = 201;
        public static const ADD_CONVOY_COUNT:int = 202;
        public static const ADD_HIJACK_COUNT:int = 203;
        public static const ADD_SIRIKE_COPY_COUNT:int = 204;
        public static const ADD_INVADE_ATTACK:int = 205;
        public static const ADD_QUEST_RICHESOFFER:int = 206;
        public static const ADD_SLAY_DAMAGE:int = 207;
        public static const REDUCE_PVP_MOVE_ENERY:int = 208;
        public static const GET_ONLINE_REWARS:int = 209;
        public static const GET_INVADE_HONOR:int = 210;
        public static const GET_PET_GP_PLUS:int = 211;
        public static const GET_MAGICSOUL_PLUS:int = 212;
        public static const MILITARY_BLOOD_BUFF1:int = 14;
        public static const MILITARY_BLOOD_BUFF2:int = 15;
        public static const MILITARY_BLOOD_BUFF3:int = 16;

        public var Type:int;
        public var IsExist:Boolean;
        public var BeginData:Date;
        public var ValidDate:int;
        public var Value:int;
        public var ValidCount:int;
        public var isSelf:Boolean = true;
        private var _buffName:String;
        private var _buffItem:ItemTemplateInfo;
        private var _description:String;
        public var day:int;
        private var _valided:Boolean = true;

        public function BuffInfo(_arg_1:int=-1, _arg_2:Boolean=false, _arg_3:Date=null, _arg_4:int=0, _arg_5:int=0, _arg_6:int=0)
        {
            this.Type = _arg_1;
            this.IsExist = _arg_2;
            this.BeginData = _arg_3;
            this.ValidDate = _arg_4;
            this.Value = _arg_5;
            this.ValidCount = _arg_6;
            this.initItemInfo();
        }

        public function get maxCount():int
        {
            return ((!(this._buffItem == null)) ? int(this._buffItem.Property3) : 0);
        }

        public function getLeftTimeByUnit(_arg_1:Number):int
        {
            if (this.getLeftTime() > 0)
            {
                switch (_arg_1)
                {
                    case TimeManager.DAY_TICKS:
                        return (Math.floor((this.getLeftTime() / TimeManager.DAY_TICKS)));
                    case TimeManager.HOUR_TICKS:
                        return (Math.floor(((this.getLeftTime() % TimeManager.DAY_TICKS) / TimeManager.HOUR_TICKS)));
                    case TimeManager.Minute_TICKS:
                        return (Math.floor(((this.getLeftTime() % TimeManager.HOUR_TICKS) / TimeManager.Minute_TICKS)));
                };
            };
            return (0);
        }

        public function get valided():Boolean
        {
            return (this._valided);
        }

        public function calculatePayBuffValidDay():void
        {
            var _local_1:Date;
            var _local_2:Date;
            var _local_3:int;
            if (this.BeginData)
            {
                _local_1 = TimeManager.Instance.Now();
                _local_2 = new Date(this.BeginData.fullYear, this.BeginData.month, this.BeginData.date);
                _local_1 = new Date(_local_1.fullYear, _local_1.month, _local_1.date);
                _local_3 = int(((_local_1.time - _local_2.time) / TimeManager.DAY_TICKS));
                if (_local_3 < this.ValidDate)
                {
                    this._valided = true;
                    this.day = (this.ValidDate - _local_3);
                }
                else
                {
                    this._valided = false;
                };
            };
        }

        private function getLeftTime():Number
        {
            var _local_1:Number;
            if (this.IsExist)
            {
                _local_1 = (this.ValidDate - Math.floor(((TimeManager.Instance.Now().time - this.BeginData.time) / TimeManager.Minute_TICKS)));
            }
            else
            {
                _local_1 = -1;
            };
            return (_local_1 * TimeManager.Minute_TICKS);
        }

        public function get buffName():String
        {
            return (this._buffItem.Name);
        }

        public function get description():String
        {
            return (this._buffItem.Data);
        }

        public function get buffItemInfo():ItemTemplateInfo
        {
            return (this._buffItem);
        }

        public function initItemInfo():void
        {
            switch (this.Type)
            {
                case PREVENT_KICK:
                    this._buffItem = ItemManager.Instance.getTemplateById(EquipType.PREVENT_KICK);
                    return;
                case DOUBLE_GESTE:
                    this._buffItem = ItemManager.Instance.getTemplateById(EquipType.DOUBLE_GESTE_CARD);
                    return;
                case DOUBEL_EXP:
                    this._buffItem = ItemManager.Instance.getTemplateById(EquipType.DOUBLE_EXP_CARD);
                    return;
                case FREE:
                    this._buffItem = ItemManager.Instance.getTemplateById(EquipType.FREE_PROP_CARD);
                    return;
                case Caddy_Good:
                    this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Caddy_Good);
                    return;
                case Save_Life:
                    this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Save_Life);
                    return;
                case Agility:
                    this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Agility_Get);
                    return;
                case ReHealth:
                    this._buffItem = ItemManager.Instance.getTemplateById(EquipType.ReHealth);
                    return;
                case Level_Try:
                    this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Level_Try);
                    return;
                case Card_Get:
                    this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Card_Get);
                    return;
            };
        }

        public function dispose():void
        {
        }


    }
}//package ddt.data

