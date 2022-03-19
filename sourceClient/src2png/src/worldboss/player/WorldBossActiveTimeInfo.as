// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.player.WorldBossActiveTimeInfo

package worldboss.player
{
    public class WorldBossActiveTimeInfo 
    {

        private var _worldBossId:int;
        private var _worldBossName:String;
        private var _worldBossBeginTime:String;
        private var _worldBossEndTime:String;


        public function get worldBossEndTime():String
        {
            return (this._worldBossEndTime);
        }

        public function set worldBossEndTime(_arg_1:String):void
        {
            this._worldBossEndTime = _arg_1;
        }

        public function get worldBossId():int
        {
            return (this._worldBossId);
        }

        public function set worldBossId(_arg_1:int):void
        {
            this._worldBossId = _arg_1;
        }

        public function get worldBossName():String
        {
            return (this._worldBossName);
        }

        public function set worldBossName(_arg_1:String):void
        {
            this._worldBossName = _arg_1;
        }

        public function get worldBossBeginTime():String
        {
            return (this._worldBossBeginTime);
        }

        public function set worldBossBeginTime(_arg_1:String):void
        {
            this._worldBossBeginTime = _arg_1;
        }


    }
}//package worldboss.player

