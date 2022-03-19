// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.GradeExaltClewManager

package ddt.manager
{
    import flash.display.MovieClip;
    import ddt.view.character.ShowCharacter;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.events.PlayerPropertyEvent;
    import ddt.events.DuowanInterfaceEvent;
    import ddt.events.TaskEvent;
    import SingleDungeon.event.SingleDungeonEvent;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import com.pickgliss.action.FunctionAction;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import ddt.data.Experience;
    import ddt.view.character.CharactoryFactory;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.chat.ChatData;
    import ddt.view.chat.ChatInputView;
    import com.pickgliss.utils.ObjectUtils;

    public class GradeExaltClewManager 
    {

        public static const LIGHT:int = 1;
        public static const BLACK:int = 2;
        private static var instance:GradeExaltClewManager;

        private var _asset:MovieClip;
        private var _blood:MovieClip;
        private var _grade:int;
        private var _isSteup:Boolean = false;
        private var _character:ShowCharacter;
        private var _info:PlayerInfo;
        private var _needShowDownloadClient:Boolean;
        private var _increBlood:FilterFrameText;
        private var _currentNum:int = 0;
        private var _targetNum:int = 0;


        public static function getInstance():GradeExaltClewManager
        {
            if (instance == null)
            {
                instance = new (GradeExaltClewManager)();
            };
            return (instance);
        }


        public function setup():void
        {
            if (this._isSteup)
            {
                return;
            };
            this.addEvent();
            this._isSteup = true;
        }

        private function addEvent():void
        {
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__GradeExalt);
        }

        private function removeEvent():void
        {
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__GradeExalt);
        }

        private function __GradeExalt(e:PlayerPropertyEvent):void
        {
            var q:uint;
            if (((e.changedProperties["Grade"]) && (PlayerManager.Instance.Self.IsUpGrade)))
            {
                DuowanInterfaceManage.Instance.dispatchEvent(new DuowanInterfaceEvent(DuowanInterfaceEvent.UP_GRADE));
                if (e.target.Grade == this._grade)
                {
                    return;
                };
                this._grade = e.target.Grade;
                if (this._grade >= SavePointManager.SKIP_BASE_SAVEPOINT_LEVEL)
                {
                    q = 0;
                    while (q <= SavePointManager.MAX_SAVEPOINT)
                    {
                        if ((!(SavePointManager.Instance.checkInSkipSavePoint(q))))
                        {
                            SavePointManager.Instance.setSavePoint(q);
                        };
                        q++;
                    };
                    TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
                    SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
                };
                if (this._grade >= 11)
                {
                    this._needShowDownloadClient = true;
                };
                if ((!(StateManager.isInFight)))
                {
                    this.show(BLACK);
                }
                else
                {
                    CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_FIGHT, new FunctionAction(function ():void
                    {
                        show(BLACK);
                    }));
                };
            };
        }

        public function show(_arg_1:int):void
        {
            CacheSysManager.lock(CacheConsts.ALERT_IN_MOVIE);
            this.dispose();
            this._asset = ComponentFactory.Instance.creat("asset.core.upgradeClewMcOne");
            this._asset.addEventListener(Event.ENTER_FRAME, this.__cartoonFrameHandler);
            this._asset.addFrameScript(40, this.playeBloodMc);
            this._asset.gotoAndPlay(1);
            this._blood = ComponentFactory.Instance.creat("asset.core.upgradeClewMcNum");
            this._blood.visible = false;
            this._blood.x = 485;
            this._blood.y = 330;
            this._asset.addChild(this._blood);
            this._increBlood = ComponentFactory.Instance.creatComponentByStylename("core.upgradeMoive.text");
            var _local_2:int = PlayerManager.Instance.Self.Grade;
            if (_local_2 == 1)
            {
                this._increBlood.text = "100";
            }
            else
            {
                this._increBlood.text = (Experience.getBasicHP(_local_2) - Experience.getBasicHP((_local_2 - 1))).toString();
            };
            this._character = (CharactoryFactory.createCharacter(PlayerManager.Instance.Self, CharactoryFactory.SHOW, true) as ShowCharacter);
            this._character.showGun = false;
            this._character.setShowLight(false);
            this._character.showWing = false;
            this._character.show(false, 1, false);
            this._asset.character.addChild(this._character);
            SoundManager.instance.play("063");
            this._asset.buttonMode = (this._asset.mouseChildren = (this._asset.mouseEnabled = false));
            if (_arg_1 == LIGHT)
            {
                LayerManager.Instance.addToLayer(this._asset, LayerManager.STAGE_TOP_LAYER, false);
            }
            else
            {
                LayerManager.Instance.addToLayer(this._asset, LayerManager.STAGE_TOP_LAYER, false, LayerManager.BLCAK_BLOCKGOUND);
            };
            var _local_3:ChatData = new ChatData();
            _local_3.msg = LanguageMgr.GetTranslation("tank.manager.GradeExaltClewManager");
            _local_3.channel = ChatInputView.SYS_NOTICE;
            ChatManager.Instance.chat(_local_3);
        }

        private function playeBloodMc():void
        {
            this._blood.visible = true;
            this._blood.gotoAndPlay(1);
            this._blood.addEventListener(Event.COMPLETE, this.__bloodCompleteHandler);
        }

        private function __bloodFrameHandler(_arg_1:Event):void
        {
            this.playeAndStopNum(this._currentNum);
            this._currentNum = (((Math.round((Math.random() * 9)) * 100) + (Math.round((Math.random() * 9)) * 10)) + Math.round((Math.random() * 9)));
        }

        private function __bloodCompleteHandler(_arg_1:Event):void
        {
            this._blood.stop();
            this._blood.removeEventListener(Event.COMPLETE, this.__bloodCompleteHandler);
            this.playeAndStopNum(int(this._increBlood.text));
        }

        private function playeAndStopNum(_arg_1:int):void
        {
            _arg_1 = Math.abs(_arg_1);
            this.setNum(_arg_1);
        }

        private function setNum(_arg_1:int):void
        {
            _arg_1 = Math.abs(_arg_1);
            var _local_2:int = int(((_arg_1 % 10000) / 1000));
            var _local_3:int = int((((_arg_1 % 10000) % 1000) / 100));
            var _local_4:int = int(((((_arg_1 % 10000) % 1000) % 100) / 10));
            var _local_5:int = ((((_arg_1 % 10000) % 1000) % 100) % 10);
            if (_local_3 == 0)
            {
                this._blood.num_1.visible = false;
            };
            this._blood.num_1.gotoAndStop((_local_3 + 1));
            this._blood.num_2.gotoAndStop((_local_4 + 1));
            this._blood.num_3.gotoAndStop((_local_5 + 1));
        }

        private function end():void
        {
            this._asset.gotoAndStop(this._asset.totalFrames);
            this.hide();
        }

        private function __cartoonFrameHandler(_arg_1:Event):void
        {
            if (this._asset == null)
            {
                return;
            };
            if (this._asset.currentFrame == this._asset.totalFrames)
            {
                this.end();
                CacheSysManager.unlock(CacheConsts.ALERT_IN_MOVIE);
                CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_MOVIE, 1000);
            };
        }

        private function hide():void
        {
            this.dispose();
            if (this._grade >= 11)
            {
                TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.SHOW_DOWNLOAD_FRAME));
            };
        }

        private function dispose():void
        {
            if (this._asset)
            {
                this._asset.removeEventListener(Event.ENTER_FRAME, this.__cartoonFrameHandler);
                ObjectUtils.disposeObject(this._asset);
            };
            this._asset = null;
            if (this._blood)
            {
                this._blood.removeEventListener(Event.COMPLETE, this.__bloodCompleteHandler);
                ObjectUtils.disposeObject(this._blood);
            };
            this._blood = null;
            if (this._increBlood)
            {
                ObjectUtils.disposeObject(this._increBlood);
            };
            this._increBlood = null;
            if (this._character)
            {
                ObjectUtils.disposeObject(this._character);
            };
            this._character = null;
        }

        public function get needShowDownloadClient():Boolean
        {
            return (this._needShowDownloadClient);
        }

        public function set needShowDownloadClient(_arg_1:Boolean):void
        {
            this._needShowDownloadClient = _arg_1;
        }


    }
}//package ddt.manager

