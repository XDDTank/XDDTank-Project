// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//playerParticle.PlayerParticleManager

package playerParticle
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import game.GameManager;
    import game.model.GameInfo;
    import game.model.GameModeType;
    import vip.VipController;
    import game.objects.GamePlayer;
    import __AS3__.vec.*;

    public class PlayerParticleManager extends EventDispatcher 
    {

        public static var SHOW_NUM:int = 5;
        private static var _instance:PlayerParticleManager;

        private var _model:PlayerParticleModel;
        private var _start:Array;
        private var _particlePoolVec:Vector.<PlayerParticlePool>;
        private var _IDArr:Array;
        private var _alphaArr:Array;
        private var _tempCount:int = 0;
        private var _pos1:Point;
        private var _pos2:Point;

        public function PlayerParticleManager()
        {
            this._model = new PlayerParticleModel();
            this._particlePoolVec = new Vector.<PlayerParticlePool>();
            this._IDArr = new Array();
            this._start = new Array();
            this._alphaArr = new Array();
            var _local_1:int = 1;
            while (_local_1 <= SHOW_NUM)
            {
                this._alphaArr.push((_local_1 * 0.1));
                _local_1++;
            };
            this._pos1 = ComponentFactory.Instance.creatCustomObject("plaerparticleManager.point1");
            this._pos2 = ComponentFactory.Instance.creatCustomObject("plaerparticleManager.point2");
        }

        public static function get instance():PlayerParticleManager
        {
            if ((!(_instance)))
            {
                _instance = new (PlayerParticleManager)();
            };
            return (_instance);
        }


        public function get model():PlayerParticleModel
        {
            return (this._model);
        }

        public function startParticle(_arg_1:Function, _arg_2:Function, _arg_3:GamePlayer):void
        {
            var _local_4:GameInfo = GameManager.Instance.Current;
            var _local_5:int = _arg_3.Id;
            var _local_6:int;
            if (_arg_3.player.playerInfo.IsVIP)
            {
                _local_6 = _arg_3.player.playerInfo.VIPLevel;
            };
            if ((((this._start[this.getNumByID(_local_5)]) || (!(VipController.instance.getPrivilegeByIndexAndLevel(8, _local_6)))) || (((!(_local_4.gameMode == GameModeType.SINGLE_DUNGOEN)) && (!(_local_4.gameMode == GameModeType.SIMPLE_DUNGOEN))) && (!(_local_4.gameMode == GameModeType.MULTI_DUNGEON)))))
            {
                return;
            };
            if ((!(this.checkID(_local_5))))
            {
                this._IDArr.push(_local_5);
                this._particlePoolVec.push(new PlayerParticlePool());
                this._particlePoolVec[this.getNumByID(_local_5)].creatPlayerParticle(_arg_1, _arg_2, SHOW_NUM);
                this.model.posArray.push(new Array());
                this._start.push(true);
            };
            this._start[this.getNumByID(_local_5)] = true;
            this.model.posArray[this.getNumByID(_local_5)] = new Array();
        }

        public function stopParticle(_arg_1:GamePlayer):void
        {
            this._start[this.getNumByID(_arg_1.Id)] = false;
        }

        public function saveParticlePos(_arg_1:Point, _arg_2:int, _arg_3:int):void
        {
            if ((!(this._start[this.getNumByID(_arg_3)])))
            {
                return;
            };
            _arg_1.x = (_arg_1.x - this._pos1.x);
            _arg_1.y = (_arg_1.y - this._pos1.y);
            if (_arg_2 == -1)
            {
                _arg_1.x = (_arg_1.x + this._pos2.x);
            };
            if (this._start[this.getNumByID(_arg_3)])
            {
                this._tempCount++;
                if ((this._tempCount % 3) == 0)
                {
                    this.model.posArray[this.getNumByID(_arg_3)].push(_arg_1);
                    if (this.model.posArray[this.getNumByID(_arg_3)].length > SHOW_NUM)
                    {
                        this.model.posArray[this.getNumByID(_arg_3)].shift();
                    };
                    this.model.direction = _arg_2;
                    this._tempCount = 0;
                };
            };
        }

        public function showParticle(_arg_1:int):void
        {
            var _local_2:Point;
            var _local_3:Number;
            var _local_4:PlayerParticle;
            if ((!(this.checkID(_arg_1))))
            {
                return;
            };
            if (this._particlePoolVec[this.getNumByID(_arg_1)])
            {
                this._particlePoolVec[this.getNumByID(_arg_1)].clear();
            };
            var _local_5:int = (this.model.posArray[this.getNumByID(_arg_1)].length - 1);
            while (_local_5 >= 0)
            {
                _local_2 = this.model.posArray[this.getNumByID(_arg_1)][_local_5];
                _local_3 = this._alphaArr[_local_5];
                _local_4 = this._particlePoolVec[this.getNumByID(_arg_1)].checkOut();
                _local_4.direction = this.model.direction;
                _local_4.x = (_local_2.x - _local_4.player.x);
                _local_4.y = (_local_2.y - _local_4.player.y);
                _local_4.visible = true;
                _local_4.alpha = _local_3;
                _local_5--;
            };
            if ((!(this._start[this.getNumByID(_arg_1)])))
            {
                if (this.model.posArray[this.getNumByID(_arg_1)].length > 0)
                {
                    this.model.posArray[this.getNumByID(_arg_1)].shift();
                };
            };
        }

        public function checkID(_arg_1:int):Boolean
        {
            var _local_2:int;
            for each (_local_2 in this._IDArr)
            {
                if (_local_2 == _arg_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function getNumByID(_arg_1:int):int
        {
            var _local_2:int;
            while (_local_2 < this._IDArr.length)
            {
                if (_arg_1 == this._IDArr[_local_2])
                {
                    return (_local_2);
                };
                _local_2++;
            };
            return (-1);
        }

        public function dispose():void
        {
            var _local_1:PlayerParticlePool;
            this.model.reset();
            for each (_local_1 in this._particlePoolVec)
            {
                _local_1.dispose();
                _local_1 = null;
            };
            this._start = new Array();
            this._IDArr = new Array();
            this._particlePoolVec = new Vector.<PlayerParticlePool>();
        }


    }
}//package playerParticle

