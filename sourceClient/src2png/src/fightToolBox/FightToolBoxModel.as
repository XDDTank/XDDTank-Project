// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//fightToolBox.FightToolBoxModel

package fightToolBox
{
    public class FightToolBoxModel 
    {

        private var _fightVipLevel_low:int = 0;
        private var _fightVipLevel_mid:int = 0;
        private var _fightVipLevel_high:int = 0;
        private var _fightVipTime_low:int = 0;
        private var _fightVipTime_mid:int = 0;
        private var _fightVipTime_high:int = 0;
        private var _fightVipPrice_low:int = 0;
        private var _fightVipPrice_mid:int = 0;
        private var _fightVipPrice_high:int = 0;
        private var _fightVipDamage_low:int = 0;
        private var _fightVipDamage_mid:int = 0;
        private var _fightVipDamage_high:int = 0;
        private var _guideDamageRatio_0:Number = 0;
        private var _guideDamageRatio_1:Number = 0;
        private var _guideDamageRatio_2:Number = 0;
        private var _guideDamageRatio_3:Number = 0;
        private var _guideDamageIncrease:Number = 0;
        private var _powerDamageRatio:Number = 0;
        private var _powerDamageIncrease:Number = 0;
        private var _headShotDamageRatio:Number = 0;


        public function get fightVipPrice_high():int
        {
            return (this._fightVipPrice_high);
        }

        public function set fightVipPrice_high(_arg_1:int):void
        {
            this._fightVipPrice_high = _arg_1;
        }

        public function get fightVipPrice_mid():int
        {
            return (this._fightVipPrice_mid);
        }

        public function set fightVipPrice_mid(_arg_1:int):void
        {
            this._fightVipPrice_mid = _arg_1;
        }

        public function get fightVipPrice_low():int
        {
            return (this._fightVipPrice_low);
        }

        public function set fightVipPrice_low(_arg_1:int):void
        {
            this._fightVipPrice_low = _arg_1;
        }

        public function get fightVipTime_high():int
        {
            return (this._fightVipTime_high);
        }

        public function set fightVipTime_high(_arg_1:int):void
        {
            this._fightVipTime_high = _arg_1;
        }

        public function get fightVipTime_mid():int
        {
            return (this._fightVipTime_mid);
        }

        public function set fightVipTime_mid(_arg_1:int):void
        {
            this._fightVipTime_mid = _arg_1;
        }

        public function get fightVipTime_low():int
        {
            return (this._fightVipTime_low);
        }

        public function set fightVipTime_low(_arg_1:int):void
        {
            this._fightVipTime_low = _arg_1;
        }

        public function get fightVipLevel_high():int
        {
            return (this._fightVipLevel_high);
        }

        public function set fightVipLevel_high(_arg_1:int):void
        {
            this._fightVipLevel_high = _arg_1;
        }

        public function get fightVipLevel_mid():int
        {
            return (this._fightVipLevel_mid);
        }

        public function set fightVipLevel_mid(_arg_1:int):void
        {
            this._fightVipLevel_mid = _arg_1;
        }

        public function get fightVipLevel_low():int
        {
            return (this._fightVipLevel_low);
        }

        public function set fightVipLevel_low(_arg_1:int):void
        {
            this._fightVipLevel_low = _arg_1;
        }

        public function get fightVipDamage_low():int
        {
            return (this._fightVipDamage_low);
        }

        public function set fightVipDamage_low(_arg_1:int):void
        {
            this._fightVipDamage_low = _arg_1;
        }

        public function get fightVipDamage_mid():int
        {
            return (this._fightVipDamage_mid);
        }

        public function set fightVipDamage_mid(_arg_1:int):void
        {
            this._fightVipDamage_mid = _arg_1;
        }

        public function get fightVipDamage_high():int
        {
            return (this._fightVipDamage_high);
        }

        public function set fightVipDamage_high(_arg_1:int):void
        {
            this._fightVipDamage_high = _arg_1;
        }

        public function get guideDamageRatio_0():Number
        {
            return (this._guideDamageRatio_0);
        }

        public function set guideDamageRatio_0(_arg_1:Number):void
        {
            this._guideDamageRatio_0 = _arg_1;
        }

        public function get guideDamageRatio_1():Number
        {
            return (this._guideDamageRatio_1);
        }

        public function set guideDamageRatio_1(_arg_1:Number):void
        {
            this._guideDamageRatio_1 = _arg_1;
        }

        public function get guideDamageRatio_2():Number
        {
            return (this._guideDamageRatio_2);
        }

        public function set guideDamageRatio_2(_arg_1:Number):void
        {
            this._guideDamageRatio_2 = _arg_1;
        }

        public function get guideDamageRatio_3():Number
        {
            return (this._guideDamageRatio_3);
        }

        public function set guideDamageRatio_3(_arg_1:Number):void
        {
            this._guideDamageRatio_3 = _arg_1;
        }

        public function getguideDamageRatioByLevel(_arg_1:int):int
        {
            var _local_2:Number = 0;
            switch (_arg_1)
            {
                case 0:
                    _local_2 = this.guideDamageRatio_0;
                    break;
                case 1:
                    _local_2 = this.guideDamageRatio_1;
                    break;
                case 2:
                    _local_2 = this.guideDamageRatio_2;
                    break;
                case 3:
                    _local_2 = this.guideDamageRatio_3;
                    break;
            };
            return ((_local_2 - 1) * 100);
        }

        public function get guideDamageIncrease():Number
        {
            return (this._guideDamageIncrease);
        }

        public function set guideDamageIncrease(_arg_1:Number):void
        {
            this._guideDamageIncrease = _arg_1;
        }

        public function get powerDamageRatio():Number
        {
            return (this._powerDamageRatio);
        }

        public function set powerDamageRatio(_arg_1:Number):void
        {
            this._powerDamageRatio = _arg_1;
        }

        public function get powerDamageIncrease():Number
        {
            return (this._powerDamageIncrease);
        }

        public function set powerDamageIncrease(_arg_1:Number):void
        {
            this._powerDamageIncrease = _arg_1;
        }

        public function get headShotDamageRatio():Number
        {
            return (this._headShotDamageRatio);
        }

        public function set headShotDamageRatio(_arg_1:Number):void
        {
            this._headShotDamageRatio = _arg_1;
        }


    }
}//package fightToolBox

