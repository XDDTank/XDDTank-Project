// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.MessageTipManager

package ddt.manager
{
    import flash.display.Sprite;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.DisplayObject;
    import flash.utils.Timer;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.ui.UICreatShortcut;
    import com.pickgliss.ui.ComponentFactory;
    import flash.text.AntiAliasType;
    import com.greensock.TweenMax;
    import com.greensock.easing.Quint;
    import com.pickgliss.ui.LayerManager;
    import flash.events.TimerEvent;
    import flash.utils.Dictionary;

    public class MessageTipManager 
    {

        private static var instance:MessageTipManager;

        private var _messageTip:Sprite;
        private var _tipString:String;
        private var _tipText:FilterFrameText;
        private var _tipBg:DisplayObject;
        private var _isPlaying:Boolean;
        private var _currentType:int;
        private var _ghostPropContent:PropMessageHolder;
        private var _emptyGridContent:EmptyGridMsgHolder;
        private var _autoUsePropContent:AutoUsePropMessage;
        private var _tipContainer:Sprite;
        private var _duration:Number;
        private var _showTimer:Timer;
        private var _showArr:Array;

        public function MessageTipManager()
        {
            this._tipContainer = new Sprite();
            this._tipContainer.mouseChildren = (this._tipContainer.mouseEnabled = false);
            this._tipContainer.y = (StageReferance.stageHeight >> 1);
            this._messageTip = new Sprite();
            this._tipBg = UICreatShortcut.creatAndAdd("core.Scale9CornerImage23", this._tipContainer);
            this._tipText = UICreatShortcut.creatAndAdd("core.messageTip.TipText", this._messageTip);
            this._tipText.filters = ComponentFactory.Instance.creatFilters("core.messageTip.TipTextFilter_1");
            this._tipText.antiAliasType = AntiAliasType.ADVANCED;
            this._tipText.mouseEnabled = (this._messageTip.mouseEnabled = false);
            this._messageTip.mouseChildren = false;
            this._ghostPropContent = new PropMessageHolder();
            this._ghostPropContent.x = 130;
            this._ghostPropContent.y = 10;
            this._emptyGridContent = new EmptyGridMsgHolder();
            this._emptyGridContent.x = 130;
            this._emptyGridContent.y = 10;
            this._autoUsePropContent = new AutoUsePropMessage();
            this._autoUsePropContent.x = 130;
            this._autoUsePropContent.y = 10;
        }

        public static function getInstance():MessageTipManager
        {
            if (instance == null)
            {
                instance = new (MessageTipManager)();
            };
            return (instance);
        }


        public function get currentType():int
        {
            return (this._currentType);
        }

        public function get isPlaying():Boolean
        {
            return (this._isPlaying);
        }

        private function setContent(_arg_1:String):DisplayObject
        {
            this.cleanContent();
            this._tipString = _arg_1;
            this._tipText.autoSize = "center";
            this._tipText.text = this._tipString;
            this._tipBg.width = (this._tipText.textWidth + 260);
            this._tipBg.height = (this._tipText.textHeight + 20);
            this._tipBg.x = ((StageReferance.stageWidth - this._tipBg.width) >> 1);
            this._tipContainer.addChild(this._tipBg);
            this._tipContainer.addChild(this._messageTip);
            return (this._tipContainer);
        }

        private function setGhostPropContent(_arg_1:String):DisplayObject
        {
            this.cleanContent();
            this._ghostPropContent.setContent(_arg_1);
            this._tipBg.width = (this._ghostPropContent.width + 260);
            this._tipBg.height = (this._ghostPropContent.height + 20);
            this._tipBg.x = ((StageReferance.stageWidth - this._tipBg.width) >> 1);
            this._ghostPropContent.x = (this._tipBg.x + 130);
            this._tipContainer.addChild(this._tipBg);
            this._tipContainer.addChild(this._ghostPropContent);
            return (this._tipContainer);
        }

        private function setFullPropContent(_arg_1:String):DisplayObject
        {
            this.cleanContent();
            this._emptyGridContent.setContent(_arg_1);
            this._tipBg.width = (this._emptyGridContent.width + 260);
            this._tipBg.height = (this._emptyGridContent.height + 20);
            this._tipBg.x = ((StageReferance.stageWidth - this._tipBg.width) >> 1);
            this._emptyGridContent.x = (this._tipBg.x + 130);
            this._tipContainer.addChild(this._tipBg);
            this._tipContainer.addChild(this._emptyGridContent);
            return (this._tipContainer);
        }

        private function setAutoUsePropContent(_arg_1:String):DisplayObject
        {
            this.cleanContent();
            this._autoUsePropContent.setContent(_arg_1);
            this._tipBg.width = (this._autoUsePropContent.width + 260);
            this._tipBg.height = (this._autoUsePropContent.height + 20);
            this._tipBg.x = ((StageReferance.stageWidth - this._tipBg.width) >> 1);
            this._autoUsePropContent.x = (this._tipBg.x + 130);
            this._tipContainer.addChild(this._tipBg);
            this._tipContainer.addChild(this._autoUsePropContent);
            return (this._tipContainer);
        }

        private function cleanContent():void
        {
            while (this._tipContainer.numChildren > 0)
            {
                this._tipContainer.removeChildAt(0);
            };
        }

        private function showTip(_arg_1:DisplayObject, _arg_2:Boolean=false, _arg_3:Number=0.3):void
        {
            if (((!(_arg_2)) && (this._isPlaying)))
            {
                return;
            };
            if (((this._tipContainer.parent) && (this._isPlaying)))
            {
                TweenMax.killChildTweensOf(this._tipContainer.parent);
            };
            this._isPlaying = true;
            this._duration = _arg_3;
            var _local_4:int = int((((StageReferance.stageHeight - _arg_1.height) / 2) - 10));
            TweenMax.fromTo(_arg_1, 0.3, {
                "y":((StageReferance.stageHeight / 2) + 20),
                "alpha":0,
                "ease":Quint.easeIn,
                "onComplete":this.onTipToCenter,
                "onCompleteParams":[_arg_1]
            }, {
                "y":_local_4,
                "alpha":1
            });
            LayerManager.Instance.addToLayer(_arg_1, LayerManager.STAGE_DYANMIC_LAYER, false, 0, false);
        }

        private function showByTimer(_arg_1:TimerEvent):void
        {
            var _local_2:String;
            var _local_3:int;
            var _local_4:Boolean;
            var _local_5:Number;
            if (this._showArr.length > 0)
            {
                _local_2 = this._showArr[0]["str"];
                _local_3 = this._showArr[0]["type"];
                _local_4 = this._showArr[0]["replace"];
                _local_5 = this._showArr[0]["duration"];
                this._showArr.shift();
                this.showMsg(_local_2, _local_3, _local_4, _local_5);
            };
            this._showTimer.stop();
            this._showTimer.removeEventListener(TimerEvent.TIMER, this.showByTimer);
            this._showTimer = null;
            if (this._showArr.length > 0)
            {
                this.show(this._showArr[0]["str"], this._showArr[0]["type"], this._showArr[0]["replace"], this._showArr[0]["duration"]);
            };
        }

        private function showMsg(_arg_1:String, _arg_2:int=0, _arg_3:Boolean=false, _arg_4:Number=0.3):void
        {
            var _local_5:DisplayObject;
            if (((!(_arg_3)) && (this._isPlaying)))
            {
                return;
            };
            this._tipString = _arg_1;
            switch (_arg_2)
            {
                case 1:
                    _local_5 = this.setGhostPropContent(_arg_1);
                    break;
                case 2:
                    _local_5 = this.setFullPropContent(_arg_1);
                    break;
                case 3:
                    _local_5 = this.setAutoUsePropContent(_arg_1);
                    break;
                default:
                    _local_5 = this.setContent(_arg_1);
            };
            this._currentType = _arg_2;
            this.showTip(_local_5, _arg_3, _arg_4);
        }

        public function show(_arg_1:String, _arg_2:int=0, _arg_3:Boolean=false, _arg_4:Number=0.3):void
        {
            var _local_5:Dictionary;
            if ((!(this._showArr)))
            {
                this._showArr = new Array();
            };
            if ((!(this._showTimer)))
            {
                this.showMsg(_arg_1, _arg_2, _arg_3, _arg_4);
                this._showTimer = new Timer(1000, 1);
                this._showTimer.addEventListener(TimerEvent.TIMER, this.showByTimer);
                this._showTimer.start();
            }
            else
            {
                if (this._showTimer.running)
                {
                    if (((this._showArr.length > 0) && (!(_arg_1 == this._showArr[(this._showArr.length - 1)]["str"]))))
                    {
                        _local_5 = new Dictionary();
                        _local_5["str"] = _arg_1;
                        _local_5["type"] = _arg_2;
                        _local_5["replace"] = _arg_3;
                        _local_5["duration"] = _arg_4;
                        this._showArr.push(_local_5);
                    };
                }
                else
                {
                    if (this._showArr.length >= 1)
                    {
                        this.showByTimer(null);
                    }
                    else
                    {
                        this._showTimer.stop();
                        this._showTimer.removeEventListener(TimerEvent.TIMER, this.showByTimer);
                        this._showTimer = null;
                    };
                };
            };
        }

        private function onTipToCenter(_arg_1:DisplayObject):void
        {
            TweenMax.to(_arg_1, this._duration, {
                "alpha":0,
                "ease":Quint.easeOut,
                "onComplete":this.hide,
                "onCompleteParams":[_arg_1],
                "delay":1.2
            });
        }

        public function kill():void
        {
            this._isPlaying = false;
            if (this._tipContainer.parent)
            {
                this._tipContainer.parent.removeChild(this._tipContainer);
            };
            TweenMax.killTweensOf(this._tipContainer);
        }

        public function hide(_arg_1:DisplayObject):void
        {
            this._isPlaying = false;
            this._tipString = null;
            if (_arg_1.parent)
            {
                _arg_1.parent.removeChild(_arg_1);
            };
            TweenMax.killTweensOf(_arg_1);
        }


    }
}//package ddt.manager

import flash.display.Sprite;
import com.pickgliss.ui.text.FilterFrameText;
import com.pickgliss.ui.ComponentFactory;
import ddt.manager.LanguageMgr;
import ddt.manager.ItemManager;
import ddt.data.goods.ItemTemplateInfo;
import game.GameManager;
import game.model.Living;
import bagAndInfo.cell.BaseCell;
import flash.display.DisplayObject;
import com.pickgliss.ui.core.Disposeable;
import flash.display.Shape;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Matrix;
import flash.display.Graphics;
import flash.filters.ColorMatrixFilter;

class EmptyGridMsgHolder extends Sprite 
{

    /*private*/ var _textField:FilterFrameText;
    /*private*/ var _item:PropHolder;

    public function EmptyGridMsgHolder()
    {
        mouseChildren = (mouseEnabled = false);
        this._textField = ComponentFactory.Instance.creatComponentByStylename("MessageTip.TextField");
        this._textField.x = 0;
        this._textField.text = LanguageMgr.GetTranslation("tank.MessageTip.EmptyGrid");
        addChild(this._textField);
        this._item = new PropHolder();
        addChild(this._item);
    }

    public function setContent(_arg_1:String):void
    {
        var _local_2:ItemTemplateInfo = ItemManager.Instance.getTemplateById(int(_arg_1));
        this._item.setInfo(_local_2);
        this._item.x = ((this._textField.x + this._textField.width) - 4);
    }


}

class PropMessageHolder extends Sprite 
{

    /*private*/ var _head:HeadHolder;
    /*private*/ var _textField:FilterFrameText;
    /*private*/ var _item:PropHolder;

    public function PropMessageHolder()
    {
        mouseChildren = (mouseEnabled = false);
        this._head = new HeadHolder();
        addChild(this._head);
        this._textField = ComponentFactory.Instance.creatComponentByStylename("MessageTip.TextField");
        this._textField.text = LanguageMgr.GetTranslation("tank.MessageTip.GhostProp");
        addChild(this._textField);
        this._item = new PropHolder();
        addChild(this._item);
    }

    public function setContent(_arg_1:String):void
    {
        var _local_2:Array = _arg_1.split("|");
        var _local_3:Living = GameManager.Instance.Current.findLiving(_local_2[0]);
        this._head.setInfo(_local_3);
        var _local_4:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_local_2[1]);
        this._item.setInfo(_local_4);
        this._textField.x = (this._head.width - 3);
        this._item.x = ((this._textField.x + this._textField.width) - 4);
    }


}

class AutoUsePropMessage extends Sprite 
{

    /*private*/ var _head:HeadHolder;
    /*private*/ var _textField:FilterFrameText;
    /*private*/ var _item:PropHolder;

    public function AutoUsePropMessage()
    {
        mouseChildren = (mouseEnabled = false);
        this._head = new HeadHolder(false);
        addChild(this._head);
        this._textField = ComponentFactory.Instance.creatComponentByStylename("MessageTip.TextField");
        addChild(this._textField);
        this._item = new PropHolder();
        addChild(this._item);
    }

    public function setContent(_arg_1:String):void
    {
        var _local_2:Living;
        _local_2 = GameManager.Instance.Current.findLiving(int(_arg_1));
        this._head.setInfo(_local_2);
        var _local_3:ItemTemplateInfo = ItemManager.Instance.getTemplateById(10029);
        this._item.setInfo(_local_3);
        this._textField.x = (this._head.width - 3);
        this._textField.text = (_local_2.name + LanguageMgr.GetTranslation("tank.MessageTip.AutoGuide"));
        this._item.x = ((this._textField.x + this._textField.width) - 4);
    }


}

class PropHolder extends Sprite 
{

    /*private*/ var _itemCell:BaseCell;
    /*private*/ var _fore:DisplayObject;
    /*private*/ var _nameField:FilterFrameText;

    public function PropHolder()
    {
        this._itemCell = new BaseCell(ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.back"), null, false, false);
        addChild(this._itemCell);
        this._fore = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.fore");
        this._fore.x = (this._fore.y = 1);
        addChild(this._fore);
        this._nameField = ComponentFactory.Instance.creatComponentByStylename("MessageTip.Prop.TextField");
        addChild(this._nameField);
    }

    public function setInfo(_arg_1:ItemTemplateInfo):void
    {
        this._nameField.text = _arg_1.Name;
        this._itemCell.x = ((this._nameField.x + this._nameField.textWidth) + 4);
        this._fore.x = (this._itemCell.x + 1);
        this._itemCell.info = _arg_1;
    }


}

class HeadHolder extends Sprite implements Disposeable 
{

    /*private*/ var _back:DisplayObject;
    /*private*/ var _fore:DisplayObject;
    /*private*/ var _headShape:Shape;
    /*private*/ var _buff:BitmapData;
    /*private*/ var _drawRect:Rectangle = new Rectangle(0, 0, 36, 36);
    /*private*/ var _drawMatrix:Matrix = new Matrix();
    /*private*/ var _nameField:FilterFrameText;

    public function HeadHolder(_arg_1:Boolean=true)
    {
        this._back = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.back");
        addChild(this._back);
        this._buff = new BitmapData(36, 36, true, 0);
        this._headShape = new Shape();
        var _local_2:Graphics = this._headShape.graphics;
        _local_2.beginBitmapFill(this._buff);
        _local_2.drawRect(0, 0, 36, 36);
        _local_2.endFill();
        if (_arg_1)
        {
            this._headShape.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0])];
        };
        addChild(this._headShape);
        this._fore = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.fore");
        this._fore.x = (this._fore.y = 1);
        addChild(this._fore);
        this._nameField = ComponentFactory.Instance.creatComponentByStylename("MessageTip.GhostProp.NameField");
        addChild(this._nameField);
    }

    public function setInfo(_arg_1:Living):void
    {
        this._buff.fillRect(this._drawRect, 0);
        var _local_2:Rectangle = this.getHeadRect(_arg_1);
        this._drawMatrix.identity();
        this._drawMatrix.scale((this._buff.width / _local_2.width), (this._buff.height / _local_2.height));
        this._drawMatrix.translate(((-(_local_2.x) * this._drawMatrix.a) + 4), ((-(_local_2.y) * this._drawMatrix.d) + 6));
        this._buff.draw(_arg_1.character.characterBitmapdata, this._drawMatrix);
        if (_arg_1.playerInfo != null)
        {
            this._nameField.text = _arg_1.playerInfo.NickName;
        }
        else
        {
            this._nameField.text = _arg_1.name;
        };
        this._nameField.setFrame(_arg_1.team);
    }

    /*private*/ function getHeadRect(_arg_1:Living):Rectangle
    {
        if (((_arg_1.playerInfo.getShowSuits()) && (_arg_1.playerInfo.getSuitsType() == 1)))
        {
            return (new Rectangle(21, 12, 167, 165));
        };
        return (new Rectangle(16, 58, 170, 170));
    }

    public function hide():void
    {
    }

    public function dispose():void
    {
    }


}


