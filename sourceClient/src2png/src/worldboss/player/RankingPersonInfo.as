// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.player.RankingPersonInfo

package worldboss.player
{
    public class RankingPersonInfo 
    {

        private var _userId:int;
        private var _id:int;
        private var _name:String;
        private var _damage:int;
        private var _percentage:Number;
        private var _isVip:Boolean;
        private var _typeVip:int;
        private var _point:int;
        private var _nickName:String;


        public function get userId():int
        {
            return (this._userId);
        }

        public function set userId(_arg_1:int):void
        {
            this._userId = _arg_1;
        }

        public function get point():int
        {
            return (this._point);
        }

        public function set point(_arg_1:int):void
        {
            this._point = _arg_1;
        }

        public function get nickName():String
        {
            return (this._nickName);
        }

        public function set nickName(_arg_1:String):void
        {
            this._nickName = _arg_1;
        }

        public function set typeVip(_arg_1:int):void
        {
            this._typeVip = _arg_1;
        }

        public function get typeVip():int
        {
            return (this._typeVip);
        }

        public function get isVip():Boolean
        {
            return (this._isVip);
        }

        public function set isVip(_arg_1:Boolean):void
        {
            this._isVip = _arg_1;
        }

        public function set id(_arg_1:int):void
        {
            this._id = _arg_1;
        }

        public function get id():int
        {
            return (this._id);
        }

        public function set name(_arg_1:String):void
        {
            this._name = _arg_1;
        }

        public function get name():String
        {
            return (this._name);
        }

        public function set damage(_arg_1:int):void
        {
            this._damage = _arg_1;
        }

        public function get damage():int
        {
            return (this._damage);
        }

        public function set percentage(_arg_1:Number):void
        {
            this._percentage = _arg_1;
        }

        public function get percentage():Number
        {
            return (this._percentage);
        }

        public function getPercentage(_arg_1:Number):String
        {
            if (this._damage >= _arg_1)
            {
                return ("100%");
            };
            return (((this._damage / _arg_1) * 100).toString().substr(0, 5) + "%");
        }


    }
}//package worldboss.player

