// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.PlayerThumbnailTip

package ddt.view.tips
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.tip.ITip;
    import com.pickgliss.ui.image.Image;
    import __AS3__.vec.Vector;
    import ddt.view.SimpleItem;
    import game.view.playerThumbnail.PlayerThumbnail;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import com.pickgliss.toplevel.StageReferance;
    import game.view.playerThumbnail.HeadFigure;
    import bagAndInfo.info.PlayerInfoViewControl;
    import ddt.manager.PlayerManager;
    import ddt.manager.ChatManager;
    import ddt.manager.MessageTipManager;
    import im.IMController;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.vo.DirectionPos;
    import __AS3__.vec.*;

    [Event(name="playerThumbnailTipItemClick", type="flash.events.Event")]
    public class PlayerThumbnailTip extends Sprite implements Disposeable, ITip 
    {

        public static const VIEW_INFO:int = 0;
        public static const MAKE_FRIEND:int = 1;
        public static const PRIVATE_CHAT:int = 2;

        private var _bg:Image;
        private var _items:Vector.<SimpleItem>;
        private var _playerTipDisplay:PlayerThumbnail;

        public function PlayerThumbnailTip()
        {
            this.init();
        }

        public function init():void
        {
            var _local_1:Point;
            var _local_3:SimpleItem;
            this._bg = ComponentFactory.Instance.creatComponentByStylename("game.playerThumbnailTipBg");
            addChild(this._bg);
            this._items = new Vector.<SimpleItem>();
            _local_1 = PositionUtils.creatPoint("game.PlayerThumbnailTipItemPos");
            var _local_2:int;
            while (_local_2 < 3)
            {
                _local_3 = ComponentFactory.Instance.creatComponentByStylename("game.PlayerThumbnailTipItem");
                (_local_3.foreItems[0] as FilterFrameText).text = LanguageMgr.GetTranslation(("game.PlayerThumbnailTipItemText_" + _local_2.toString()));
                _local_3.addEventListener(MouseEvent.ROLL_OVER, this.__onMouseOver);
                _local_3.addEventListener(MouseEvent.ROLL_OUT, this.__onMouseOut);
                _local_3.addEventListener(MouseEvent.CLICK, this.__onMouseClick);
                _local_3.backItem.visible = false;
                _local_3.buttonMode = true;
                _local_3.x = _local_1.x;
                _local_3.y = _local_1.y;
                _local_1.y = (_local_1.y + (_local_3.height - 2));
                this._items.push(_local_3);
                addChild(_local_3);
                _local_2++;
            };
            addEventListener(Event.ADDED_TO_STAGE, this.__addStageEvent);
            addEventListener(Event.REMOVED_FROM_STAGE, this.__removeFromStage);
        }

        public function set tipDisplay(_arg_1:PlayerThumbnail):void
        {
            this._playerTipDisplay = _arg_1;
        }

        public function get tipDisplay():PlayerThumbnail
        {
            return (this._playerTipDisplay);
        }

        private function __addStageEvent(_arg_1:Event):void
        {
            StageReferance.stage.addEventListener(MouseEvent.CLICK, this.__removeStageEvent);
        }

        private function __removeStageEvent(_arg_1:MouseEvent):void
        {
            if ((_arg_1.target is HeadFigure))
            {
                return;
            };
            StageReferance.stage.removeEventListener(MouseEvent.CLICK, this.__removeStageEvent);
            _arg_1.stopImmediatePropagation();
            _arg_1.stopPropagation();
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function __removeFromStage(_arg_1:Event):void
        {
            dispatchEvent(new Event("playerThumbnailTipItemClick"));
        }

        private function __onMouseOver(_arg_1:MouseEvent):void
        {
            var _local_2:SimpleItem = (_arg_1.currentTarget as SimpleItem);
            if (((_local_2) && (_local_2.backItem)))
            {
                _local_2.backItem.visible = true;
            };
        }

        private function __onMouseOut(_arg_1:MouseEvent):void
        {
            var _local_2:SimpleItem = (_arg_1.currentTarget as SimpleItem);
            if (((_local_2) && (_local_2.backItem)))
            {
                _local_2.backItem.visible = false;
            };
        }

        private function __onMouseClick(_arg_1:MouseEvent):void
        {
            var _local_4:Boolean;
            var _local_2:SimpleItem = (_arg_1.currentTarget as SimpleItem);
            var _local_3:int = this._items.indexOf(_local_2);
            switch (_local_3)
            {
                case VIEW_INFO:
                    PlayerInfoViewControl.view(this._playerTipDisplay.info, false);
                    break;
                case MAKE_FRIEND:
                    if (((this._playerTipDisplay.info.ZoneID > 0) && (!(this._playerTipDisplay.info.ZoneID == PlayerManager.Instance.Self.ZoneID))))
                    {
                        ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.AddFriendUnable"));
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("core.crossZone.AddFriendUnable"));
                    }
                    else
                    {
                        IMController.Instance.addFriend(this._playerTipDisplay.info.NickName);
                    };
                    break;
                case PRIVATE_CHAT:
                    if (((this._playerTipDisplay.info.ZoneID > 0) && (!(this._playerTipDisplay.info.ZoneID == PlayerManager.Instance.Self.ZoneID))))
                    {
                        ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.PrivateChatToUnable"));
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("core.crossZone.PrivateChatToUnable"));
                    }
                    else
                    {
                        ChatManager.Instance.privateChatTo(this._playerTipDisplay.info.NickName);
                        _local_4 = true;
                    };
                    break;
            };
            StageReferance.stage.removeEventListener(MouseEvent.CLICK, this.__removeStageEvent);
            if (parent)
            {
                parent.removeChild(this);
            };
            if (_local_4)
            {
                ChatManager.Instance.setFocus();
            };
        }

        public function get tipData():Object
        {
            return (null);
        }

        public function set tipData(_arg_1:Object):void
        {
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            var _local_2:SimpleItem;
            ObjectUtils.disposeObject(this._bg);
            var _local_1:int;
            while (_local_1 < this._items.length)
            {
                _local_2 = this._items[_local_1];
                _local_2.removeEventListener(MouseEvent.ROLL_OVER, this.__onMouseOver);
                _local_2.removeEventListener(MouseEvent.ROLL_OUT, this.__onMouseOut);
                _local_2.removeEventListener(MouseEvent.CLICK, this.__onMouseClick);
                ObjectUtils.disposeObject(_local_2);
                _local_2 = null;
                _local_1++;
            };
            this._playerTipDisplay = null;
            this._items = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get currentDirectionPos():DirectionPos
        {
            return (null);
        }

        public function set currentDirectionPos(_arg_1:DirectionPos):void
        {
        }


    }
}//package ddt.view.tips

