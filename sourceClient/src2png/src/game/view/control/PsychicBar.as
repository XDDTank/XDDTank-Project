// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.control.PsychicBar

package game.view.control
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import game.model.LocalPlayer;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;
    import ddt.utils.PositionUtils;
    import ddt.events.LivingEvent;
    import com.pickgliss.utils.ObjectUtils;
    import flash.display.Shape;
    import flash.geom.Rectangle;
    import game.objects.SimpleBox;
    import com.greensock.TweenLite;
    import flash.display.BitmapData;
    import flash.display.Graphics;

    public class PsychicBar extends Sprite implements Disposeable 
    {

        private var _self:LocalPlayer;
        private var _back:DisplayObject;
        private var _localPsychic:int;
        private var _numField:PsychicShape;
        private var _movie:MovieClip;
        private var _ghostBoxCenter:Point;
        private var _ghostBitmapPool:Object = new Object();
        private var _mouseArea:MouseArea;

        public function PsychicBar(_arg_1:LocalPlayer)
        {
            this._self = _arg_1;
            super();
            this.configUI();
            mouseEnabled = false;
        }

        private function configUI():void
        {
            this._back = ComponentFactory.Instance.creatBitmap("asset.game.PsychicBar.back");
            addChild(this._back);
            this._ghostBoxCenter = new Point(((this._back.width >> 1) - 20), ((this._back.height >> 1) - 20));
            this._movie = ClassUtils.CreatInstance("asset.game.PsychicBar.movie");
            this._movie.mouseChildren = (this._movie.mouseEnabled = false);
            PositionUtils.setPos(this._movie, "PsychicBar.MoviePos");
            addChild(this._movie);
            this._numField = new PsychicShape();
            this._numField.setNum(this._self.psychic);
            this._numField.x = ((this._back.width - this._numField.width) >> 1);
            this._numField.y = ((this._back.height - this._numField.height) >> 1);
            addChild(this._numField);
            this._mouseArea = new MouseArea(48);
            addChild(this._mouseArea);
        }

        private function addEvent():void
        {
            this._self.addEventListener(LivingEvent.PSYCHIC_CHANGED, this.__psychicChanged);
            this._self.addEventListener(LivingEvent.BOX_PICK, this.__pickBox);
        }

        private function boxTweenComplete(_arg_1:DisplayObject):void
        {
            ObjectUtils.disposeObject(_arg_1);
        }

        private function __pickBox(_arg_1:LivingEvent):void
        {
            var _local_3:Shape;
            var _local_4:Rectangle;
            var _local_2:SimpleBox = (_arg_1.paras[0] as SimpleBox);
            if (_local_2.isGhost)
            {
                _local_3 = this.getGhostShape(_local_2.subType);
                addChild(_local_3);
                _local_4 = _local_2.getBounds(this);
                _local_3.x = _local_4.x;
                _local_3.y = _local_4.y;
                TweenLite.to(_local_3, (0.3 + (0.3 * Math.random())), {
                    "x":this._ghostBoxCenter.x,
                    "y":this._ghostBoxCenter.y,
                    "onComplete":this.boxTweenComplete,
                    "onCompleteParams":[_local_3]
                });
            };
        }

        private function __psychicChanged(_arg_1:LivingEvent):void
        {
            this._numField.setNum(this._self.psychic);
            this._numField.x = ((this._back.width - this._numField.width) >> 1);
            this._mouseArea.setPsychic(this._self.psychic);
        }

        private function removeEvent():void
        {
            this._self.removeEventListener(LivingEvent.PSYCHIC_CHANGED, this.__psychicChanged);
            this._self.removeEventListener(LivingEvent.BOX_PICK, this.__pickBox);
        }

        public function enter():void
        {
            this.addEvent();
        }

        public function leaving():void
        {
            this.removeEvent();
        }

        public function dispose():void
        {
            var _local_1:String;
            var _local_2:BitmapData;
            this.removeEvent();
            TweenLite.killTweensOf(this);
            ObjectUtils.disposeObject(this._back);
            this._back = null;
            ObjectUtils.disposeObject(this._numField);
            this._numField = null;
            ObjectUtils.disposeObject(this._mouseArea);
            this._mouseArea = null;
            if (this._movie)
            {
                this._movie.stop();
                ObjectUtils.disposeObject(this._movie);
                this._movie = null;
            };
            this._self = null;
            for (_local_1 in this._ghostBitmapPool)
            {
                _local_2 = (this._ghostBitmapPool[_local_1] as BitmapData);
                if (_local_2)
                {
                    _local_2.dispose();
                };
                delete this._ghostBitmapPool[_local_1];
            };
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function getGhostShape(_arg_1:int):Shape
        {
            var _local_4:BitmapData;
            var _local_6:MovieClip;
            var _local_2:Shape = new Shape();
            var _local_3:String = ("ghost" + _arg_1);
            if (this._ghostBitmapPool.hasOwnProperty(_local_3))
            {
                _local_4 = this._ghostBitmapPool[_local_3];
            }
            else
            {
                _local_6 = (ClassUtils.CreatInstance(("asset.game.GhostBox" + (_arg_1 - 1))) as MovieClip);
                _local_6.gotoAndStop("shot");
                _local_4 = new BitmapData(_local_6.width, _local_6.height, true, 0);
                _local_4.draw(_local_6);
                this._ghostBitmapPool[_local_3] = _local_4;
            };
            var _local_5:Graphics = _local_2.graphics;
            _local_5.beginBitmapFill(_local_4);
            _local_5.drawRect(0, 0, _local_4.width, _local_4.height);
            _local_5.endFill();
            return (_local_2);
        }


    }
}//package game.view.control

import flash.display.Sprite;
import com.pickgliss.ui.core.Disposeable;
import __AS3__.vec.Vector;
import ddt.display.BitmapShape;
import ddt.manager.BitmapManager;
import com.pickgliss.utils.ObjectUtils;
import ddt.view.tips.ChangeNumToolTip;
import ddt.view.tips.ChangeNumToolTipInfo;
import flash.display.Graphics;
import flash.events.MouseEvent;
import com.pickgliss.ui.ComponentFactory;
import ddt.manager.LanguageMgr;
import game.model.Player;
import com.pickgliss.ui.LayerManager;
import flash.geom.Rectangle;
import __AS3__.vec.*;

class PsychicShape extends Sprite implements Disposeable 
{

    /*private*/ var _nums:Vector.<BitmapShape> = new Vector.<BitmapShape>();
    /*private*/ var _num:int = 0;
    /*private*/ var _bitmapMgr:BitmapManager;

    public function PsychicShape()
    {
        this._bitmapMgr = BitmapManager.getBitmapMgr(BitmapManager.GameView);
        mouseChildren = (mouseEnabled = false);
        this.draw();
    }

    /*private*/ function draw():void
    {
        var _local_3:BitmapShape;
        this.clear();
        var _local_1:String = this._num.toString();
        var _local_2:int = _local_1.length;
        var _local_4:int;
        while (_local_4 < _local_2)
        {
            _local_3 = this._bitmapMgr.creatBitmapShape(("asset.game.PsychicBar.Num" + _local_1.substr(_local_4, 1)));
            if (_local_4 > 0)
            {
                _local_3.x = (this._nums[(_local_4 - 1)].x + this._nums[(_local_4 - 1)].width);
            };
            addChild(_local_3);
            this._nums.push(_local_3);
            _local_4++;
        };
    }

    /*private*/ function clear():void
    {
        var _local_1:BitmapShape = this._nums.shift();
        while (_local_1)
        {
            _local_1.dispose();
            _local_1 = this._nums.shift();
        };
    }

    public function setNum(_arg_1:int):void
    {
        if (this._num != _arg_1)
        {
            this._num = _arg_1;
            this.draw();
        };
    }

    public function dispose():void
    {
        this.clear();
        ObjectUtils.disposeObject(this._bitmapMgr);
        this._bitmapMgr = null;
        if (parent)
        {
            parent.removeChild(this);
        };
    }


}

class MouseArea extends Sprite implements Disposeable 
{

    /*private*/ var _tipData:String;
    /*private*/ var _tipPanel:ChangeNumToolTip;
    /*private*/ var _tipInfo:ChangeNumToolTipInfo;

    public function MouseArea(_arg_1:int)
    {
        var _local_2:Graphics = graphics;
        _local_2.beginFill(0, 0);
        _local_2.drawCircle(_arg_1, _arg_1, _arg_1);
        _local_2.endFill();
        this.addTip();
        this.addEvent();
    }

    public function setPsychic(_arg_1:int):void
    {
        this._tipInfo.current = _arg_1;
        this._tipPanel.tipData = this._tipInfo;
    }

    /*private*/ function addEvent():void
    {
        addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
    }

    /*private*/ function removeEvent():void
    {
        removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
        removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
    }

    public function dispose():void
    {
        this.removeEvent();
        this.__mouseOut(null);
        ObjectUtils.disposeObject(this._tipPanel);
        this._tipPanel = null;
        if (parent)
        {
            parent.removeChild(this);
        };
    }

    /*private*/ function addTip():void
    {
        this._tipPanel = new ChangeNumToolTip();
        this._tipInfo = new ChangeNumToolTipInfo();
        this._tipInfo.currentTxt = ComponentFactory.Instance.creatComponentByStylename("game.DanderStrip.currentTxt");
        this._tipInfo.title = LanguageMgr.GetTranslation("tank.game.PsychicBar.Title");
        this._tipInfo.current = 0;
        this._tipInfo.total = Player.MaxPsychic;
        this._tipInfo.content = LanguageMgr.GetTranslation("tank.game.PsychicBar.Content");
        this._tipPanel.tipData = this._tipInfo;
        this._tipPanel.mouseChildren = false;
        this._tipPanel.mouseEnabled = false;
    }

    /*private*/ function __mouseOut(_arg_1:MouseEvent):void
    {
        if (((this._tipPanel) && (this._tipPanel.parent)))
        {
            this._tipPanel.parent.removeChild(this._tipPanel);
        };
    }

    /*private*/ function __mouseOver(_arg_1:MouseEvent):void
    {
        var _local_2:Rectangle = getBounds(LayerManager.Instance.getLayerByType(LayerManager.STAGE_TOP_LAYER));
        this._tipPanel.x = _local_2.right;
        this._tipPanel.y = (_local_2.top - this._tipPanel.height);
        LayerManager.Instance.addToLayer(this._tipPanel, LayerManager.STAGE_TOP_LAYER, false);
    }


}


