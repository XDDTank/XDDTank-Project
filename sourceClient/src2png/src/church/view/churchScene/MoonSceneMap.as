// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.churchScene.MoonSceneMap

package church.view.churchScene
{
    import church.model.ChurchRoomModel;
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.utils.Timer;
    import ddt.manager.SoundManager;
    import ddt.view.scenePathSearcher.SceneScene;
    import road7th.data.DictionaryData;
    import ddt.view.sceneCharacter.SceneCharacterEvent;
    import com.pickgliss.utils.ClassUtils;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import baglocked.BaglockedManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import flash.events.Event;
    import flash.events.TimerEvent;

    public class MoonSceneMap extends SceneMap 
    {

        public static const GAME_WIDTH:int = 1000;
        public static const GAME_HEIGHT:int = 600;
        public static const YF_OFSET:int = 230;
        public static const FIRE_TEMPLETEID:int = 22001;

        private var _model:ChurchRoomModel;
        private var saluteContainer:Sprite;
        private var saluteMask:MovieClip;
        private var _isSaluteFiring:Boolean;
        private var saluteQueue:Array;
        private var timer:Timer;

        public function MoonSceneMap(_arg_1:ChurchRoomModel, _arg_2:SceneScene, _arg_3:DictionaryData, _arg_4:Sprite, _arg_5:Sprite, _arg_6:Sprite=null, _arg_7:Sprite=null)
        {
            this._model = _arg_1;
            super(this._model, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            SoundManager.instance.playMusic("3003");
            this.initSaulte();
        }

        private function get isSaluteFiring():Boolean
        {
            return (this._isSaluteFiring);
        }

        private function set isSaluteFiring(_arg_1:Boolean):void
        {
            if (this._isSaluteFiring == _arg_1)
            {
                return;
            };
            this._isSaluteFiring = _arg_1;
            if (this._isSaluteFiring)
            {
                this.playSaluteSound();
            }
            else
            {
                this.stopSaluteSound();
            };
        }

        override public function setCenter(_arg_1:SceneCharacterEvent=null):void
        {
            var _local_2:Number;
            var _local_3:Number;
            if (reference)
            {
                _local_2 = -(reference.x - (GAME_WIDTH / 2));
                _local_3 = (-(reference.y - (GAME_HEIGHT / 2)) + YF_OFSET);
            }
            else
            {
                _local_2 = -(sceneMapVO.defaultPos.x - (GAME_WIDTH / 2));
                _local_3 = (-(sceneMapVO.defaultPos.y - (GAME_HEIGHT / 2)) + YF_OFSET);
            };
            if (_local_2 > 0)
            {
                _local_2 = 0;
            };
            if (_local_2 < (GAME_WIDTH - sceneMapVO.mapW))
            {
                _local_2 = (GAME_WIDTH - sceneMapVO.mapW);
            };
            if (_local_3 > 0)
            {
                _local_3 = 0;
            };
            if (_local_3 < (GAME_HEIGHT - sceneMapVO.mapH))
            {
                _local_3 = (GAME_HEIGHT - sceneMapVO.mapH);
            };
            x = _local_2;
            y = _local_3;
        }

        private function initSaulte():void
        {
            var _local_1:int = this.getChildIndex(articleLayer);
            this.saluteContainer = new Sprite();
            addChildAt(this.saluteContainer, _local_1);
            this.saluteMask = (new ((ClassUtils.uiSourceDomain.getDefinition("asset.church.room.FireMaskOfMoonSceneAsset") as Class))() as MovieClip);
            addChild(this.saluteMask);
            this.saluteContainer.mask = this.saluteMask;
            this.saluteQueue = [];
            nameVisible();
            chatBallVisible();
            fireVisible();
        }

        override public function setSalute(_arg_1:int):void
        {
            var _local_3:MovieClip;
            if (((this.isSaluteFiring) && (_arg_1 == PlayerManager.Instance.Self.ID)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.scene.MoonSceneMap.lipao"));
                return;
            };
            if (_arg_1 == PlayerManager.Instance.Self.ID)
            {
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    BaglockedManager.Instance.show();
                    return;
                };
                SocketManager.Instance.out.sendGunSalute(_arg_1, FIRE_TEMPLETEID);
            };
            var _local_2:Class = (ClassUtils.uiSourceDomain.getDefinition("tank.church.fireAcect.Salute") as Class);
            _local_3 = new (_local_2)();
            var _local_4:Point = ComponentFactory.Instance.creatCustomObject("church.MoonSceneMap.saluteFirePos");
            _local_3.x = _local_4.x;
            _local_3.y = _local_4.y;
            if (this.isSaluteFiring)
            {
                this.saluteQueue.push(_local_3);
            }
            else
            {
                this.isSaluteFiring = true;
                _local_3.addEventListener(Event.ENTER_FRAME, this.saluteFireFrameHandler);
                _local_3.gotoAndPlay(1);
                this.saluteContainer.addChild(_local_3);
            };
        }

        private function saluteFireFrameHandler(_arg_1:Event):void
        {
            var _local_3:MovieClip;
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            if (_local_2.currentFrame == _local_2.totalFrames)
            {
                this.isSaluteFiring = false;
                this.clearnSaluteFire();
                _local_3 = this.saluteQueue.shift();
                if (_local_3)
                {
                    this.isSaluteFiring = true;
                    _local_3.addEventListener(Event.ENTER_FRAME, this.saluteFireFrameHandler);
                    _local_3.gotoAndPlay(1);
                    this.saluteContainer.addChild(_local_3);
                };
            };
        }

        private function clearnSaluteFire():void
        {
            while (this.saluteContainer.numChildren > 0)
            {
                this.saluteContainer.getChildAt(0).removeEventListener(Event.ENTER_FRAME, this.saluteFireFrameHandler);
                this.saluteContainer.removeChildAt(0);
            };
        }

        private function playSaluteSound():void
        {
            this.timer = new Timer(100);
            this.timer.addEventListener(TimerEvent.TIMER, this.__timer);
            this.timer.start();
        }

        private function __timer(_arg_1:TimerEvent):void
        {
            var _local_2:uint;
            var _local_3:Boolean;
            _local_2 = Math.round((Math.random() * 15));
            if (_local_2 < 6)
            {
                _local_3 = ((!(Math.round((Math.random() * 9)) % 3)) ? true : false);
                if (_local_3)
                {
                    SoundManager.instance.play("118");
                };
            };
        }

        private function stopSaluteSound():void
        {
            if (this.timer)
            {
                this.timer.removeEventListener(TimerEvent.TIMER, this.__timer);
                this.timer = null;
            };
        }

        override public function dispose():void
        {
            super.dispose();
            if (this.timer)
            {
                this.timer.removeEventListener(TimerEvent.TIMER, this.__timer);
            };
            this.timer = null;
            if (((this.saluteMask) && (this.saluteMask.parent)))
            {
                this.saluteMask.parent.removeChild(this.saluteMask);
            };
            this.saluteMask = null;
            this.clearnSaluteFire();
            this.stopSaluteSound();
            if (((this.saluteContainer) && (this.saluteContainer.parent)))
            {
                this.saluteContainer.parent.removeChild(this.saluteContainer);
            };
            this.saluteContainer = null;
            if (parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package church.view.churchScene

