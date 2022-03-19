// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.objects.BossPlayer

package game.objects
{
    import flash.display.Sprite;
    import pet.date.PetSkillInfo;
    import game.model.Player;
    import ddt.view.character.ShowCharacter;
    import ddt.view.character.GameCharacter;
    import flash.display.MovieClip;
    import ddt.view.FaceContainer;
    import flash.geom.Point;
    import road7th.data.DictionaryData;
    import game.model.Living;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ClassUtils;
    import ddt.events.LivingEvent;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatEvent;
    import game.actions.PrepareShootAction;
    import game.actions.ShootBombAction;
    import game.actions.PlayerWalkAction;
    import game.actions.PlayerFallingAction;
    import game.actions.GhostMoveAction;
    import ddt.manager.PetSkillManager;
    import game.GameManager;
    import ddt.events.GameEvent;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.EquipType;
    import phy.maps.Map;
    import ddt.view.chat.chatBall.ChatBallPlayer;
    import ddt.view.chat.ChatData;
    import ddt.utils.Helpers;
    import flash.utils.setTimeout;
    import com.pickgliss.loader.ModuleLoader;
    import com.pickgliss.utils.ObjectUtils;

    public class BossPlayer extends GameTurnedLiving 
    {

        protected var _playerSprite:Sprite;
        protected var _petMovie:GamePetMovie;
        protected var _currentPetSkill:PetSkillInfo;
        protected var _shootAction:String = "beatA";
        protected var _player:Player;
        private var _character:ShowCharacter;
        private var _body:GameCharacter;
        private var _readyMc:MovieClip;
        protected var _facecontainer:FaceContainer;
        protected var _attackPlayerCite:MovieClip;
        private var _point:Point;
        public var UsedPetSkill:DictionaryData = new DictionaryData();

        public function BossPlayer(_arg_1:Player, _arg_2:ShowCharacter, _arg_3:GameCharacter=null)
        {
            this._character = _arg_2;
            this._body = _arg_3;
            this._player = (_arg_1 as Player);
            _arg_1.defaultAction = Living.STAND_ACTION;
            super(_arg_1);
            if (this.player.currentPet)
            {
                this._petMovie = new GamePetMovie(this.player.currentPet.petInfo, this);
                this._petMovie.addEventListener(GamePetMovie.PlayEffect, this.__playPlayerEffect);
            };
        }

        public function get character():ShowCharacter
        {
            return (this._character);
        }

        public function get body():GameCharacter
        {
            return (this._body);
        }

        public function get player():Player
        {
            return (this._player);
        }

        override protected function initMovie():void
        {
            super.initMovie();
            _actionMovie.gotoAndPlay("born");
        }

        override protected function initView():void
        {
            this._point = ComponentFactory.Instance.creatCustomObject("tian.shootSpeed1");
            this.initMovie();
            this._facecontainer = new FaceContainer();
            addChild(this._facecontainer);
            this._facecontainer.y = -150;
            super.initView();
            this._facecontainer.setNickName(_nickName.text);
            this._playerSprite = new Sprite();
            this._playerSprite.rotation = 0;
            this._playerSprite.visible = false;
            addChild(this._playerSprite);
            this._playerSprite.mouseChildren = (this._playerSprite.mouseEnabled = false);
            this._body.x = 0;
            this._body.doAction(GameCharacter.SOUL);
            this._playerSprite.addChild((this._body as DisplayObject));
            this._attackPlayerCite = (ClassUtils.CreatInstance("asset.game.AttackCiteAsset") as MovieClip);
            this._attackPlayerCite.y = -115;
            this._attackPlayerCite.mouseChildren = (this._attackPlayerCite.mouseEnabled = false);
            this.__dirChanged(null);
        }

        override public function doAction(_arg_1:*):void
        {
            if ((((!(_actionMovie.currentAction == "stand")) && (!(_actionMovie.currentAction == "walk"))) && (_arg_1 == "walk")))
            {
                return;
            };
            super.doAction(_arg_1);
        }

        public function get point():Point
        {
            return (this._point);
        }

        override protected function initListener():void
        {
            super.initListener();
            this.player.addEventListener(LivingEvent.POS_CHANGED, this.__posChanged);
            this.player.addEventListener(LivingEvent.USING_ITEM, this.__usingItem);
            this.player.addEventListener(LivingEvent.PLAYER_MOVETO, this.__playerMoveTo);
            this.player.addEventListener(LivingEvent.USE_PET_SKILL, this.__usePetSkill);
            this.player.addEventListener(LivingEvent.PET_BEAT, this.__petBeat);
            ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE, this.__getFace);
            ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT, this.__getChat);
            this.player.addEventListener(LivingEvent.READY_FOR_PLAYING, this.__onReady);
        }

        override protected function __beginNewTurn(_arg_1:LivingEvent):void
        {
            super.__beginNewTurn(_arg_1);
            if (_isLiving)
            {
            };
            if (contains(this._attackPlayerCite))
            {
                removeChild(this._attackPlayerCite);
            };
        }

        override protected function __shoot(_arg_1:LivingEvent):void
        {
            var _local_2:Array = _arg_1.paras[0];
            this.player.currentBomb = _local_2[0].Template.ID;
            map.act(new PrepareShootAction(this));
            map.act(new ShootBombAction(this, _local_2, _arg_1.paras[1], this._point.y, this._shootAction));
            this._shootAction = ActionType.BEAT_A;
        }

        override protected function removeListener():void
        {
            super.removeListener();
            this.player.removeEventListener(LivingEvent.POS_CHANGED, this.__posChanged);
            this.player.removeEventListener(LivingEvent.USING_ITEM, this.__usingItem);
            this.player.removeEventListener(LivingEvent.PLAYER_MOVETO, this.__playerMoveTo);
            this.player.removeEventListener(LivingEvent.USE_PET_SKILL, this.__usePetSkill);
            this.player.removeEventListener(LivingEvent.PET_BEAT, this.__petBeat);
            ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE, this.__getFace);
            ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT, this.__getChat);
            this.player.removeEventListener(LivingEvent.READY_FOR_PLAYING, this.__onReady);
        }

        protected function attackingViewChanged():void
        {
            if (((this.player.isAttacking) && (this.player.isLiving)))
            {
                this._attackPlayerCite.gotoAndStop(_info.team);
                addChild(this._attackPlayerCite);
            }
            else
            {
                if (contains(this._attackPlayerCite))
                {
                    removeChild(this._attackPlayerCite);
                };
            };
        }

        override protected function __attackingChanged(_arg_1:LivingEvent):void
        {
            super.__attackingChanged(_arg_1);
            this.attackingViewChanged();
        }

        override protected function __dirChanged(_arg_1:LivingEvent):void
        {
            if (_info.direction > 0)
            {
                movie.scaleX = -1;
                this._playerSprite.scaleX = -1;
            }
            else
            {
                movie.scaleX = 1;
                this._playerSprite.scaleX = 1;
            };
            if (this._facecontainer)
            {
                this._facecontainer.scaleX = 1;
            };
        }

        protected function __playerMoveTo(_arg_1:LivingEvent):void
        {
            var _local_2:int = _arg_1.paras[0];
            switch (_local_2)
            {
                case 0:
                    act(new PlayerWalkAction(this, _arg_1.paras[1], _arg_1.paras[2]));
                    return;
                case 1:
                    act(new PlayerFallingAction(this, _arg_1.paras[1], _arg_1.paras[3], false));
                    return;
                case 2:
                    act(new GhostMoveAction(this, _arg_1.paras[1], _arg_1.paras[4]));
                    return;
                case 3:
                    act(new PlayerFallingAction(this, _arg_1.paras[1], _arg_1.paras[3], true));
                    return;
                case 4:
                    act(new PlayerWalkAction(this, _arg_1.paras[1], _arg_1.paras[2]));
                    return;
            };
        }

        protected function __usePetSkill(_arg_1:LivingEvent):void
        {
            var _local_2:PetSkillInfo = PetSkillManager.instance.getSkillByID(_arg_1.value);
            if (_local_2 == null)
            {
                throw (new Error(("找不到技能，技能ID为：" + _arg_1.value)));
            };
            if (_local_2.isActiveSkill)
            {
                switch (_local_2.BallType)
                {
                    case PetSkillInfo.BALL_TYPE_0:
                        this.usePetSkill(_local_2);
                        break;
                    case PetSkillInfo.BALL_TYPE_1:
                        if (GameManager.Instance.Current.selfGamePlayer.team == info.team)
                        {
                            this._shootAction = _local_2.Action;
                            GameManager.Instance.Current.selfGamePlayer.soulPropEnabled = false;
                            dispatchEvent(new GameEvent(GameEvent.BOSS_USE_SKILL));
                        };
                        break;
                    case PetSkillInfo.BALL_TYPE_2:
                        if (GameManager.Instance.Current.selfGamePlayer.team == info.team)
                        {
                            GameManager.Instance.Current.selfGamePlayer.soulPropEnabled = false;
                        };
                        this.usePetSkill(_local_2, this.stand);
                        break;
                    case PetSkillInfo.BALL_TYPE_3:
                        this.usePetSkill(_local_2);
                        break;
                };
                this.UsedPetSkill.add(_local_2.ID, _local_2);
                SoundManager.instance.play("039");
            };
        }

        override protected function __bloodChanged(_arg_1:LivingEvent):void
        {
            if (_arg_1.paras[0] == 0)
            {
                if (_actionMovie != null)
                {
                    _actionMovie.doAction(Living.RENEW, super.__bloodChanged, [_arg_1]);
                };
            }
            else
            {
                if (_arg_1.paras[0] == 10)
                {
                    super.__bloodChanged(_arg_1);
                }
                else
                {
                    if (_arg_1.paras[0] == 5)
                    {
                        updateBloodStrip();
                        return;
                    };
                    super.__bloodChanged(_arg_1);
                    if (_info.State != 1)
                    {
                        this.doAction(Living.CRY_ACTION);
                    };
                };
            };
        }

        public function usePetSkill(_arg_1:PetSkillInfo, _arg_2:Function=null):void
        {
            this._currentPetSkill = _arg_1;
            this.playPetMovie(_arg_1.Action, _info.pos, _arg_2);
        }

        protected function playPetMovie(_arg_1:String, _arg_2:Point, _arg_3:Function=null, _arg_4:Array=null):void
        {
            if (_arg_3 != null)
            {
                this.actionMovie.doAction(_arg_1, _arg_3);
            };
        }

        public function stand():void
        {
        }

        protected function __onReady(_arg_1:Event):void
        {
            if (GameManager.Instance.Current.getTeamLiveCount(_info.team) <= 1)
            {
                return;
            };
            if ((!(this.player.isShowReadyMC)))
            {
                return;
            };
            if (this.player.isReady)
            {
                if ((!(this._readyMc)))
                {
                    this._readyMc = ComponentFactory.Instance.creat("game.object.bossplayer.readyAsset");
                    addChild(this._readyMc);
                };
                this._readyMc.visible = true;
                this._readyMc.gotoAndStop(1);
            }
            else
            {
                if (this._readyMc)
                {
                    this._readyMc.gotoAndStop(2);
                };
            };
        }

        protected function __petBeat(_arg_1:LivingEvent):void
        {
            var _local_2:String = _arg_1.paras[0];
            var _local_3:Point = _arg_1.paras[1];
            var _local_4:Array = _arg_1.paras[2];
            this.playPetMovie(_local_2, _local_3, this.updateHp, [_local_4]);
        }

        protected function updateHp(_arg_1:Array):void
        {
            var _local_2:Object;
            var _local_3:Living;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            for each (_local_2 in _arg_1)
            {
                _local_3 = _local_2.target;
                _local_4 = _local_2.hp;
                _local_5 = _local_2.damage;
                _local_6 = _local_2.dander;
                _local_3.updateBlood(_local_4, 3, _local_5);
                if ((_local_3 is Player))
                {
                    Player(_local_3).dander = _local_6;
                };
            };
        }

        protected function __usingItem(_arg_1:LivingEvent):void
        {
            var _local_2:ItemTemplateInfo;
            if ((_arg_1.paras[0] is ItemTemplateInfo))
            {
                _local_2 = _arg_1.paras[0];
                _propArray.push(_local_2.Pic);
                doUseItemAnimation((!(EquipType.hasPropAnimation(_arg_1.paras[0]) == null)));
            }
            else
            {
                if ((_arg_1.paras[0] is DisplayObject))
                {
                    _propArray.push(_arg_1.paras[0]);
                    doUseItemAnimation();
                };
            };
        }

        override public function setMap(_arg_1:Map):void
        {
            super.setMap(_arg_1);
            if (_arg_1)
            {
                this.__posChanged(null);
            };
        }

        override protected function initChatball():void
        {
            _chatballview = new ChatBallPlayer();
            _originalHeight = this.height;
            _originalWidth = this.width;
            addChild(_chatballview);
        }

        protected function __getChat(_arg_1:ChatEvent):void
        {
            if (((this.player.isHidden) && (!(this.player.team == GameManager.Instance.Current.selfGamePlayer.team))))
            {
                return;
            };
            if ((!(this.player.isLiving)))
            {
                return;
            };
            var _local_2:ChatData = ChatData(_arg_1.data).clone();
            _local_2.msg = Helpers.deCodeString(_local_2.msg);
            if (((_local_2.channel == 2) || (_local_2.channel == 3)))
            {
                return;
            };
            if (_local_2.zoneID == -1)
            {
                if (_local_2.senderID == this.player.playerInfo.ID)
                {
                    this.say(_local_2.msg, this.player.playerInfo.paopaoType);
                };
            }
            else
            {
                if (((_local_2.senderID == this.player.playerInfo.ID) && (_local_2.zoneID == this.player.playerInfo.ZoneID)))
                {
                    this.say(_local_2.msg, this.player.playerInfo.paopaoType);
                };
            };
        }

        protected function say(_arg_1:String, _arg_2:int):void
        {
            _chatballview.setText(_arg_1, _arg_2);
            addChild(_chatballview);
            fitChatBallPos();
        }

        protected function __getFace(_arg_1:ChatEvent):void
        {
            var _local_3:int;
            var _local_4:int;
            if (((this.player.isHidden) && (!(this.player.team == GameManager.Instance.Current.selfGamePlayer.team))))
            {
                return;
            };
            var _local_2:Object = _arg_1.data;
            if (_local_2["playerid"] == this.player.playerInfo.ID)
            {
                _local_3 = _local_2["faceid"];
                _local_4 = _local_2["delay"];
                if (_local_3 >= 49)
                {
                    setTimeout(this.showFace, _local_4, _local_3);
                }
                else
                {
                    this.showFace(_local_3);
                };
                if (((_local_3 < 49) && (_local_3 > 0)))
                {
                    ChatManager.Instance.dispatchEvent(new ChatEvent(ChatEvent.SET_FACECONTIANER_LOCTION));
                };
            };
        }

        protected function showFace(_arg_1:int):void
        {
            if (this._facecontainer == null)
            {
                return;
            };
            this._facecontainer.scaleX = 1;
            this._facecontainer.setFace(_arg_1);
        }

        override protected function __posChanged(_arg_1:LivingEvent):void
        {
            super.__posChanged(_arg_1);
        }

        protected function __playPlayerEffect(_arg_1:Event):void
        {
            if (ModuleLoader.hasDefinition(this._currentPetSkill.EffectClassLink))
            {
                this.showEffect(this._currentPetSkill.EffectClassLink);
            };
        }

        override public function die():void
        {
            super.die();
            this.player.isSpecialSkill = false;
            this.player.skill = -1;
            SoundManager.instance.play("042");
            _bloodStripBg.visible = (_HPStrip.visible = false);
            _nickName.visible = false;
            if (contains(this._attackPlayerCite))
            {
                removeChild(this._attackPlayerCite);
            };
        }

        override protected function __die(_arg_1:LivingEvent):void
        {
            if (isMoving())
            {
                stopMoving();
            };
            super.__die(_arg_1);
            if (_arg_1.paras[0])
            {
                _actionMovie.doAction(Living.DIE_ACTION, this.dieActionCallback);
            };
        }

        private function dieActionCallback():void
        {
            this._playerSprite.visible = true;
            _actionMovie.visible = false;
        }

        override public function dispose():void
        {
            super.dispose();
            while (((this._playerSprite) && (this._playerSprite.numChildren > 0)))
            {
                this._playerSprite.removeChildAt(0);
                ObjectUtils.disposeObject(this._playerSprite);
                this._playerSprite = null;
            };
            this._body = null;
            ObjectUtils.disposeObject(this._readyMc);
            this._readyMc = null;
            ObjectUtils.disposeObject(this._attackPlayerCite);
            this._attackPlayerCite = null;
            ObjectUtils.disposeObject(this._facecontainer);
            this._facecontainer = null;
        }


    }
}//package game.objects

