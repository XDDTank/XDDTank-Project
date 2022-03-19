// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.churchScene.WeddingSceneMap

package church.view.churchScene
{
    import church.model.ChurchRoomModel;
    import flash.display.MovieClip;
    import church.player.ChurchPlayer;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.utils.Timer;
    import ddt.manager.SoundManager;
    import ddt.view.scenePathSearcher.SceneScene;
    import road7th.data.DictionaryData;
    import flash.display.Sprite;
    import church.view.churchFire.ChurchFireEffectPlayer;
    import flash.geom.Point;
    import ddt.manager.ChurchManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.view.sceneCharacter.SceneCharacterEvent;
    import ddt.view.sceneCharacter.SceneCharacterDirection;
    import com.pickgliss.utils.ClassUtils;
    import flash.display.DisplayObject;
    import church.vo.FatherBallConfigVO;
    import flash.display.Shape;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.utils.BitmapUtils;
    import ddt.manager.SocketManager;
    import flash.events.TimerEvent;
    import ddt.data.ChurchRoomInfo;
    import flash.events.MouseEvent;

    public class WeddingSceneMap extends SceneMap 
    {

        public static const MOVE_SPEED:Number = 0.055;
        public static const MOVE_SPEEDII:Number = 0.15;

        private var _model:ChurchRoomModel;
        private var father_read:MovieClip;
        private var father_com:MovieClip;
        private var bride:ChurchPlayer;
        private var groom:ChurchPlayer;
        private var guestPos:Array;
        private var _fatherPaopaoBg:ScaleFrameImage;
        private var _fatherPaopao:ScaleFrameImage;
        private var _fatherPaopaoConfig:Array = [];
        private var frame:uint = 1;
        private var _brideName:FilterFrameText;
        private var _groomName:FilterFrameText;
        private var kissMovie:MovieClip;
        private var fireTimer:Timer;

        public function WeddingSceneMap(_arg_1:ChurchRoomModel, _arg_2:SceneScene, _arg_3:DictionaryData, _arg_4:Sprite, _arg_5:Sprite, _arg_6:Sprite=null, _arg_7:Sprite=null)
        {
            this._model = _arg_1;
            super(this._model, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            SoundManager.instance.playMusic("3002");
            this.initFather();
        }

        private function initFather():void
        {
            if (bgLayer != null)
            {
                this.father_read = (bgLayer.getChildByName("father_read") as MovieClip);
                this.father_com = (bgLayer.getChildByName("father_com") as MovieClip);
                if (this.father_read)
                {
                    this.father_read.visible = false;
                };
            };
        }

        public function fireImdily(_arg_1:Point, _arg_2:uint, _arg_3:Boolean=false):void
        {
            var _local_5:ChurchFireEffectPlayer;
            if (_arg_2 > 1)
            {
                return;
            };
            var _local_4:int = this._model.fireTemplateIDList[_arg_2];
            _local_5 = new ChurchFireEffectPlayer(_local_4);
            _local_5.x = _arg_1.x;
            _local_5.y = _arg_1.y;
            addChild(_local_5);
            _local_5.firePlayer(_arg_3);
        }

        public function playWeddingMovie():void
        {
            var _local_1:Point;
            this.bride = (_characters[ChurchManager.instance.currentRoom.brideID] as ChurchPlayer);
            this.groom = (_characters[ChurchManager.instance.currentRoom.groomID] as ChurchPlayer);
            this.bride.moveSpeed = MOVE_SPEED;
            this.groom.moveSpeed = MOVE_SPEED;
            _local_1 = ComponentFactory.Instance.creatCustomObject("church.WeddingSceneMap.bridePos");
            this.bride.x = _local_1.x;
            this.bride.y = _local_1.y;
            var _local_2:Point = ComponentFactory.Instance.creatCustomObject("church.WeddingSceneMap.groomPos");
            this.groom.x = _local_2.x;
            this.groom.y = _local_2.y;
            this.rangeGuest();
            ajustScreen(this.bride);
            this.bride.addEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP, this.__arrive);
            this.groom.addEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP, this.__arrive);
            this.bride.sceneCharacterActionType = "naturalWalkBack";
            this.bride.playerVO.walkPath = [new Point(1104, 660)];
            this.bride.playerWalk(this.bride.playerVO.walkPath);
            this.groom.sceneCharacterActionType = "naturalWalkBack";
            this.groom.playerVO.walkPath = [new Point(1003, 651)];
            this.groom.playerWalk(this.groom.playerVO.walkPath);
        }

        public function stopWeddingMovie():void
        {
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("church.WeddingSceneMap.bridePosII");
            this.bride.x = _local_1.x;
            this.bride.y = _local_1.y;
            this.bride.sceneCharacterDirection = SceneCharacterDirection.LB;
            this.groom.moveSpeed = MOVE_SPEEDII;
            this.groom.moveSpeed = MOVE_SPEEDII;
            ajustScreen(_selfPlayer);
            setCenter(null);
            if (this.father_read)
            {
                this.father_read.visible = false;
            };
            if (this.father_com)
            {
                this.father_com.visible = true;
            };
            this.hideDialogue();
            this.stopKissMovie();
            this.stopFireMovie();
            this.bride.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP, this.__arrive);
        }

        private function __arrive(_arg_1:SceneCharacterEvent):void
        {
            this.bride.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP, this.__arrive);
            this.groom.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP, this.__arrive);
            ajustScreen(null);
            this.bride.sceneCharacterActionType = "naturalStandFront";
            this.groom.sceneCharacterActionType = "naturalStandFront";
            this.bride.sceneCharacterDirection = SceneCharacterDirection.LB;
            this.groom.sceneCharacterDirection = SceneCharacterDirection.LB;
            this.playDialogue();
        }

        public function rangeGuest():void
        {
            var _local_2:uint;
            var _local_3:uint;
            var _local_4:ChurchPlayer;
            this.getGuestPos();
            var _local_1:Array = _characters.list;
            _local_1.sortOn("ID", Array.NUMERIC);
            while (_local_3 < _characters.length)
            {
                _local_4 = (_local_1[_local_3] as ChurchPlayer);
                if (!ChurchManager.instance.isAdmin(_local_4.playerVO.playerInfo))
                {
                    if ((_local_2 % 2))
                    {
                        _local_4.x = (this.guestPos[0][0] as Point).x;
                        _local_4.y = (this.guestPos[0][0] as Point).y;
                        (this.guestPos[0] as Array).shift();
                        _local_4.sceneCharacterActionType = "naturalStandBack";
                        _local_4.sceneCharacterDirection = SceneCharacterDirection.RT;
                    }
                    else
                    {
                        _local_4.x = (this.guestPos[1][0] as Point).x;
                        _local_4.y = (this.guestPos[1][0] as Point).y;
                        (this.guestPos[1] as Array).shift();
                        _local_4.sceneCharacterActionType = "naturalStandBack";
                        _local_4.sceneCharacterDirection = SceneCharacterDirection.LT;
                        if ((this.guestPos[1] as Array).length == 0)
                        {
                            this.guestPos.shift();
                            this.guestPos.shift();
                        };
                    };
                    _local_2++;
                };
                _local_3++;
            };
        }

        private function getGuestPos():void
        {
            var _local_3:uint;
            this.guestPos = [];
            var _local_1:Class = (ClassUtils.uiSourceDomain.getDefinition("asset.church.room.GuestLineAsset") as Class);
            var _local_2:MovieClip = (new (_local_1)() as MovieClip);
            addChild(_local_2);
            var _local_4:uint = 1;
            while (_local_4 <= 8)
            {
                if (((_local_4 == 1) || (_local_4 == 2)))
                {
                    _local_3 = 19;
                    this.guestPos.push(this.spliceLine(_local_2[("line" + _local_4)], _local_3, false, false));
                }
                else
                {
                    if ((((_local_4 == 3) || (_local_4 == 5)) || (_local_4 == 7)))
                    {
                        _local_3 = 9;
                        this.guestPos.push(this.spliceLine(_local_2[("line" + _local_4)], _local_3, false, true));
                    }
                    else
                    {
                        _local_3 = 9;
                        this.guestPos.push(this.spliceLine(_local_2[("line" + _local_4)], _local_3, true, false));
                    };
                };
                _local_4++;
            };
            removeChild(_local_2);
        }

        private function spliceLine(_arg_1:DisplayObject, _arg_2:uint, _arg_3:Boolean, _arg_4:Boolean):Array
        {
            var _local_10:uint;
            var _local_11:Point;
            var _local_5:Number = (_arg_1.width / _arg_2);
            var _local_6:Number = (_arg_1.height / _arg_2);
            var _local_7:int = ((_arg_3) ? 1 : -1);
            var _local_8:int = ((_arg_4) ? -1 : 1);
            var _local_9:Array = [];
            while (_local_10 <= _arg_2)
            {
                _local_11 = new Point();
                _local_11.x = (_arg_1.x + ((_local_5 * _local_10) * _local_7));
                _local_11.y = (_arg_1.y + ((_local_6 * _local_10) * _local_8));
                _local_9.push(_local_11);
                _local_10++;
            };
            return (_local_9);
        }

        private function playDialogue():void
        {
            var _local_2:FatherBallConfigVO;
            this.frame = 1;
            if (this.father_read)
            {
                this.father_read.visible = true;
            };
            if (this.father_com)
            {
                this.father_com.visible = false;
            };
            var _local_1:int;
            while (_local_1 < 23)
            {
                _local_2 = ComponentFactory.Instance.creatCustomObject(("church.room.FatherBallConfigVO" + (_local_1 + 1)));
                this._fatherPaopaoConfig.push(_local_2);
                _local_1++;
            };
            this._fatherPaopaoBg = ComponentFactory.Instance.creatComponentByStylename("church.room.FatherPaopaoBg");
            this._fatherPaopaoBg.setFrame(this.frame);
            addChild(this._fatherPaopaoBg);
            this._fatherPaopao = ComponentFactory.Instance.creatComponentByStylename("church.room.FatherPaopao");
            this._fatherPaopao.setFrame(this.frame);
            addChild(this._fatherPaopao);
            this.playerFatherPaopaoFrame();
        }

        private function playerFatherPaopaoFrame():void
        {
            var _local_2:Shape;
            ObjectUtils.disposeObject(this._brideName);
            this._brideName = null;
            ObjectUtils.disposeObject(this._groomName);
            this._groomName = null;
            if (((!(this._fatherPaopaoBg)) || (!(this._fatherPaopao))))
            {
                return;
            };
            if (this._fatherPaopao.getFrame >= this._fatherPaopao.totalFrames)
            {
                this.hideDialogue();
                if ((((this.bride) && (this.groom)) && (_selfPlayer)))
                {
                    this.readyForKiss();
                };
                return;
            };
            this._fatherPaopaoBg.setFrame(this.frame);
            this._fatherPaopao.setFrame(this.frame);
            switch (this.frame)
            {
                case 3:
                    this._brideName = ComponentFactory.Instance.creat("church.room.FatherPaopaoBrideName");
                    this._brideName.text = ChurchManager.instance.currentRoom.brideName;
                    addChild(this._brideName);
                    break;
                case 7:
                    this._groomName = ComponentFactory.Instance.creat("church.room.FatherPaopaoGroomName");
                    this._groomName.text = ChurchManager.instance.currentRoom.groomName;
                    addChild(this._groomName);
                    break;
                case 22:
                    this._groomName = ComponentFactory.Instance.creat("church.room.FatherPaopaoGroomName2");
                    this._groomName.text = ChurchManager.instance.currentRoom.groomName;
                    addChild(this._groomName);
                    this._brideName = ComponentFactory.Instance.creat("church.room.FatherPaopaoBrideName2");
                    this._brideName.text = ChurchManager.instance.currentRoom.brideName;
                    addChild(this._brideName);
                    break;
            };
            var _local_1:FatherBallConfigVO = (this._fatherPaopaoConfig[(this.frame - 1)] as FatherBallConfigVO);
            if (_local_1.isMask == "true")
            {
                _local_2 = new Shape();
                _local_2.x = (this._fatherPaopao.x + this._fatherPaopao.getFrameImage((this.frame - 1)).x);
                _local_2.y = (this._fatherPaopao.y + this._fatherPaopao.getFrameImage((this.frame - 1)).y);
            };
            this.frame++;
            BitmapUtils.maskMovie(this._fatherPaopao, _local_2, _local_1.isMask, _local_1.rowNumber, _local_1.rowWitdh, _local_1.rowHeight, _local_1.frameStep, _local_1.sleepSecond, this.playerFatherPaopaoFrame);
        }

        private function readyForKiss():void
        {
            this.bride.moveSpeed = 0.025;
            this.groom.moveSpeed = 0.025;
            this.groom.sceneCharacterActionType = "naturalWalkFront";
            this.groom.playerVO.walkPath = [new Point(1026, 666)];
            this.groom.playerWalk(this.groom.playerVO.walkPath);
            this.bride.sceneCharacterActionType = "naturalWalkBack";
            this.bride.playerVO.walkPath = [new Point(1060, 707), new Point(1044, 694)];
            this.bride.playerWalk(this.bride.playerVO.walkPath);
            this.playKissMovie();
            this.playFireMovie();
            this.ajustPosition();
        }

        private function ajustPosition():void
        {
            SocketManager.Instance.out.sendPosition(_selfPlayer.x, _selfPlayer.y);
        }

        private function hideDialogue():void
        {
            ObjectUtils.disposeObject(this._fatherPaopaoBg);
            this._fatherPaopaoBg = null;
            ObjectUtils.disposeObject(this._fatherPaopao);
            this._fatherPaopao = null;
            if (this.father_read)
            {
                this.father_read.visible = false;
            };
            if (this.father_com)
            {
                this.father_com.visible = true;
            };
        }

        private function playKissMovie():void
        {
            var _local_1:Class = (ClassUtils.uiSourceDomain.getDefinition("tank.church.KissMovie") as Class);
            this.kissMovie = (new (_local_1)() as MovieClip);
            this.kissMovie.x = 1040;
            this.kissMovie.y = 610;
            addChild(this.kissMovie);
        }

        private function stopKissMovie():void
        {
            if (this.kissMovie)
            {
                removeChild(this.kissMovie);
            };
            this.kissMovie = null;
        }

        public function playFireMovie():void
        {
            this.fireTimer = new Timer(100);
            this.fireTimer.addEventListener(TimerEvent.TIMER, this.__fireTimer);
            this.fireTimer.start();
        }

        private function __fireTimer(_arg_1:TimerEvent):void
        {
            var _local_2:Point;
            var _local_3:uint;
            var _local_4:Boolean;
            _local_2 = this.getFirePosition();
            _local_3 = Math.round((Math.random() * 3));
            _local_4 = ((!(Math.round((Math.random() * 9)) % 3)) ? true : false);
            this.fireImdily(_local_2, _local_3, _local_4);
        }

        private function getFirePosition():Point
        {
            var _local_3:Point;
            var _local_1:Number = (Math.round((Math.random() * (1000 - 100))) + 50);
            var _local_2:Number = (Math.round((Math.random() * (600 - 100))) + 50);
            return (this.globalToLocal(new Point(_local_1, _local_2)));
        }

        private function __fireTimerComplete(_arg_1:TimerEvent):void
        {
            if ((!(this.fireTimer)))
            {
                return;
            };
            this.fireTimer.stop();
            this.fireTimer.removeEventListener(TimerEvent.TIMER, this.__fireTimer);
            this.fireTimer = null;
        }

        private function stopFireMovie():void
        {
            this.__fireTimerComplete(null);
        }

        override protected function __click(_arg_1:MouseEvent):void
        {
            if (ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
            {
                return;
            };
            super.__click(_arg_1);
        }

        override public function dispose():void
        {
            super.dispose();
            if (this.bride)
            {
                this.bride.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP, this.__arrive);
            };
            if (this.groom)
            {
                this.groom.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP, this.__arrive);
            };
            if (this.fireTimer)
            {
                this.fireTimer.stop();
                this.fireTimer.removeEventListener(TimerEvent.TIMER, this.__fireTimer);
            };
            this.fireTimer = null;
            this.stopKissMovie();
            this.stopFireMovie();
            ObjectUtils.disposeObject(this._fatherPaopaoBg);
            this._fatherPaopaoBg = null;
            ObjectUtils.disposeObject(this._fatherPaopao);
            this._fatherPaopao = null;
            if (((this.father_read) && (this.father_read.parent)))
            {
                this.father_read.parent.removeChild(this.father_read);
            };
            this.father_read = null;
            if (((this.father_com) && (this.father_com.parent)))
            {
                this.father_com.parent.removeChild(this.father_com);
            };
            this.father_com = null;
            this.bride = null;
            this.groom = null;
            if (parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package church.view.churchScene

