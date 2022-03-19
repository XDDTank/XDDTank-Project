// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.view.TotemLeftView

package totem.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.text.FilterFrameText;
    import totem.data.TotemDataVo;
    import com.pickgliss.ui.ComponentFactory;
    import totem.TotemManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import flash.events.Event;
    import com.pickgliss.ui.LayerManager;
    import flash.events.MouseEvent;
    import ddt.events.PlayerPropertyEvent;
    import flash.geom.Point;
    import ddt.manager.SoundManager;
    import flash.text.TextFormat;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class TotemLeftView extends Sprite implements Disposeable 
    {

        private var _windowView:TotemLeftWindowView;
        private var _forwardBtn:SimpleBitmapButton;
        private var _nextBtn:SimpleBitmapButton;
        private var _currentPage:int = 1;
        private var _totalPage:int = 1;
        private var _totemTitleBg:Bitmap;
        private var _totemTitleFrameBmp:ScaleFrameImage;
        private var _honorUpIcon:HonorUpIcon;
        private var _propertyBG:Bitmap;
        private var _propertyList:Vector.<TotemRightViewTxtTxtCell>;
        private var _totalHonorBmp:Bitmap;
        private var _totalExpBmp:Bitmap;
        private var _totalHonorTxt:FilterFrameText;
        private var _totalExpTxt:FilterFrameText;
        private var _totemLvBmp:Bitmap;
        private var _totemLvTxt:FilterFrameText;
        private var _totalHonorComponent:TitleComponent;
        private var _totalExpComponent:TitleComponent;
        private var _tipView:TotemLeftWindowChapterTipView;

        public function TotemLeftView()
        {
            this.initView();
            this.createPropDisplay();
            this.createChapterTip();
            this.initEvent();
        }

        private function initView():void
        {
            var _local_1:TotemDataVo;
            this._windowView = ComponentFactory.Instance.creatCustomObject("totemLeftWindowView");
            this._forwardBtn = ComponentFactory.Instance.creatComponentByStylename("totem.leftView.page.forwardBtn");
            this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("totem.leftView.page.nextBtn");
            this._totemTitleBg = ComponentFactory.Instance.creatBitmap("asset.totem.totemTitleBg");
            this._totemTitleFrameBmp = ComponentFactory.Instance.creatComponentByStylename("totem.totemTitle");
            _local_1 = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
            this._totalHonorComponent = new TitleComponent();
            this._totalHonorComponent.tipData = LanguageMgr.GetTranslation("ddt.totem.rightView.honorTipTxt");
            this._totalExpComponent = new TitleComponent();
            this._totalExpComponent.tipData = LanguageMgr.GetTranslation("ddt.totem.rightView.expTipTxt");
            this._totalHonorBmp = ComponentFactory.Instance.creatBitmap("asset.totem.totalHonor");
            this._totalExpBmp = ComponentFactory.Instance.creatBitmap("asset.totem.totalExp");
            this._totalHonorComponent.addChild(this._totalHonorBmp);
            this._totalExpComponent.addChild(this._totalExpBmp);
            PositionUtils.setPos(this._totalHonorComponent, "totem.totalHonorPos");
            PositionUtils.setPos(this._totalExpComponent, "totem.totalExpPos");
            this._totemLvBmp = ComponentFactory.Instance.creatBitmap("asset.totem.displayLv");
            this._totemLvTxt = ComponentFactory.Instance.creatComponentByStylename("totem.currentLvTxt");
            this.upTotemLvTxt();
            this._honorUpIcon = ComponentFactory.Instance.creatCustomObject("totem.honorUpIcon");
            this._honorUpIcon.addEventListener(Event.CLOSE, this.showUserGuilde);
            this._totalHonorTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totalHonorTxt");
            this._totalExpTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totalExpTxt");
            this.propertyChangeHandler(null);
            if ((!(_local_1)))
            {
                this._currentPage = 5;
            }
            else
            {
                this._currentPage = _local_1.Page;
            };
            this.showPage();
            addChild(this._windowView);
            addChild(this._totemTitleBg);
            addChild(this._totemTitleFrameBmp);
            addChild(this._forwardBtn);
            addChild(this._nextBtn);
            addChild(this._honorUpIcon);
            addChild(this._totalHonorComponent);
            addChild(this._totalExpComponent);
            addChild(this._totalHonorTxt);
            addChild(this._totalExpTxt);
            addChild(this._totemLvBmp);
            addChild(this._totemLvTxt);
        }

        private function upTotemLvTxt():void
        {
            if (PlayerManager.Instance.Self.totemId <= 10000)
            {
                this._totemLvTxt.text = "LV0";
            }
            else
            {
                this._totemLvTxt.text = ("LV" + Math.floor(((PlayerManager.Instance.Self.totemId - 10000) / 7)));
            };
        }

        private function createChapterTip():void
        {
            this._tipView = new TotemLeftWindowChapterTipView();
            this._tipView.visible = false;
            LayerManager.Instance.addToLayer(this._tipView, LayerManager.GAME_TOP_LAYER);
        }

        private function createPropDisplay():void
        {
            var _local_2:TotemRightViewTxtTxtCell;
            this._propertyBG = ComponentFactory.Instance.creatBitmap("asset.totem.propBG");
            addChild(this._propertyBG);
            this._propertyList = new Vector.<TotemRightViewTxtTxtCell>();
            var _local_1:int = 1;
            while (_local_1 <= 7)
            {
                _local_2 = ComponentFactory.Instance.creatCustomObject(("TotemRightViewTxtTxtCell" + _local_1));
                _local_2.show(_local_1);
                _local_2.x = (100 + ((_local_1 - 1) * 108));
                _local_2.y = 432;
                addChild(_local_2);
                this._propertyList.push(_local_2);
                _local_1++;
            };
        }

        private function initEvent():void
        {
            this._forwardBtn.addEventListener(MouseEvent.CLICK, this.changePage);
            this._nextBtn.addEventListener(MouseEvent.CLICK, this.changePage);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.propertyChangeHandler);
            this._totemTitleFrameBmp.addEventListener(MouseEvent.MOUSE_OVER, this._showTip);
            this._totemTitleFrameBmp.addEventListener(MouseEvent.MOUSE_OUT, this._hideTip);
        }

        private function _showTip(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            _local_2 = this.localToGlobal(new Point((this.mouseX + 5), this.mouseY));
            this._tipView.x = (_local_2.x + 20);
            this._tipView.y = _local_2.y;
            this._tipView.show(this._currentPage);
            this._tipView.visible = true;
        }

        private function _hideTip(_arg_1:MouseEvent):void
        {
            this._tipView.visible = false;
        }

        private function changePage(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:SimpleBitmapButton = (_arg_1.currentTarget as SimpleBitmapButton);
            switch (_local_2)
            {
                case this._forwardBtn:
                    this._currentPage--;
                    if (this._currentPage < 1)
                    {
                        this._currentPage = 1;
                    };
                    break;
                case this._nextBtn:
                    this._currentPage++;
                    if (this._currentPage > this._totalPage)
                    {
                        this._currentPage = this._totalPage;
                    };
                    break;
            };
            TotemManager.instance.isUpgrade = false;
            this.showPage();
        }

        public function refreshView(_arg_1:Boolean):void
        {
            var _local_2:TotemDataVo;
            var _local_3:int;
            var _local_4:TotemDataVo;
            if (_arg_1)
            {
                _local_2 = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
                if (((((_local_2) && (!(_local_2.Page == 1))) && (_local_2.Layers == 1)) && (_local_2.Location == 1)))
                {
                    this._windowView.refreshView(_local_2, this.openSuccessAutoNextPage);
                    this.upTotemLvTxt();
                }
                else
                {
                    this._windowView.refreshView(_local_2);
                    this.refreshPageBtn();
                    this.upTotemLvTxt();
                };
                _local_3 = 0;
                while (_local_3 < 7)
                {
                    this._propertyList[_local_3].refresh();
                    _local_3++;
                };
            }
            else
            {
                _local_4 = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
                this._windowView.openFailHandler(_local_4);
            };
        }

        private function openSuccessAutoNextPage():void
        {
            this._currentPage++;
            this.showPage();
        }

        private function refreshPageBtn():void
        {
            var _local_1:int = TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId);
            this._totalPage = ((_local_1 / 70) + 1);
            this._totalPage = ((this._totalPage > 5) ? 5 : this._totalPage);
            if (this._currentPage == this._totalPage)
            {
                this._nextBtn.enable = false;
            }
            else
            {
                this._nextBtn.enable = true;
            };
            if (this._currentPage == 1)
            {
                this._forwardBtn.enable = false;
            }
            else
            {
                this._forwardBtn.enable = true;
            };
        }

        private function showPage():void
        {
            this.refreshPageBtn();
            this._windowView.show(this._currentPage, TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId), true);
            this._totemTitleFrameBmp.setFrame(this._currentPage);
        }

        private function propertyChangeHandler(_arg_1:PlayerPropertyEvent):void
        {
            this._totalHonorTxt.text = TotemManager.instance.getDisplayNum(PlayerManager.Instance.Self.totemScores);
            this._totalExpTxt.text = TotemManager.instance.getDisplayNum(TotemManager.instance.usableGP);
            var _local_2:TotemDataVo = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
            if (((_local_2) && (PlayerManager.Instance.Self.totemScores < _local_2.ConsumeHonor)))
            {
                this._totalHonorTxt.setTextFormat(new TextFormat(null, null, 0xFF0000));
            }
            else
            {
                if (this._totalHonorTxt.textColor == 0xFF0000)
                {
                    this._totalHonorTxt.setTextFormat(new TextFormat(null, null, 16499031));
                };
            };
            if (((_local_2) && (TotemManager.instance.usableGP < _local_2.ConsumeExp)))
            {
                this._totalExpTxt.setTextFormat(new TextFormat(null, null, 0xFF0000));
            }
            else
            {
                if (this._totalExpTxt.textColor == 0xFF0000)
                {
                    this._totalExpTxt.setTextFormat(new TextFormat(null, null, 16499031));
                };
            };
        }

        private function removeEvent():void
        {
            this._forwardBtn.removeEventListener(MouseEvent.CLICK, this.changePage);
            this._nextBtn.removeEventListener(MouseEvent.CLICK, this.changePage);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.propertyChangeHandler);
            this._totemTitleFrameBmp.removeEventListener(MouseEvent.MOUSE_OVER, this._showTip);
            this._totemTitleFrameBmp.removeEventListener(MouseEvent.MOUSE_OUT, this._hideTip);
            this._honorUpIcon.removeEventListener(Event.CLOSE, this.showUserGuilde);
        }

        public function showUserGuilde(_arg_1:Event=null):void
        {
            this._windowView.showUserGuilde();
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._windowView = null;
            this._totemTitleBg = null;
            this._forwardBtn = null;
            this._nextBtn = null;
            this._propertyList = null;
            this._totemTitleFrameBmp = null;
            this._honorUpIcon = null;
            this._totalExpBmp = null;
            this._totalExpTxt = null;
            this._totalHonorBmp = null;
            this._totalHonorTxt = null;
            ObjectUtils.disposeObject(this._tipView);
            this._tipView = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package totem.view

