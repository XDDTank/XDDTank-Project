// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.TakeInTurnPage

package consortion.view.selfConsortia
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class TakeInTurnPage extends Sprite implements Disposeable 
    {

        public static const PAGE_CHANGE:String = "pageChange";

        private var _bg:ScaleLeftRightImage;
        private var _bgI:ScaleLeftRightImage;
        private var _next:BaseButton;
        private var _pre:BaseButton;
        private var _page:FilterFrameText;
        private var _present:int = 1;
        private var _sum:int = 1;

        public function TakeInTurnPage()
        {
            this.initView();
            this.initEvent();
        }

        public function get present():int
        {
            return (this._present);
        }

        public function set present(_arg_1:int):void
        {
            this._present = _arg_1;
            this.setPage();
        }

        public function get sum():int
        {
            return (this._sum);
        }

        public function set sum(_arg_1:int):void
        {
            this._sum = ((_arg_1 < 1) ? 1 : _arg_1);
            if (this._present > this._sum)
            {
                this._present = 1;
            };
            this.setPage();
            this.setBtnState();
        }

        private function setPage():void
        {
            this._page.text = ((this._present + "/") + this._sum);
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creat("consortion.takeIn.pageBg");
            this._bgI = ComponentFactory.Instance.creat("consortion.takeIn.pageBgI");
            this._next = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.turnPage.next");
            this._pre = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.turnPage.pre");
            this._page = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.turnPage.page");
            addChild(this._bg);
            addChild(this._bgI);
            addChild(this._next);
            addChild(this._pre);
            addChild(this._page);
        }

        private function initEvent():void
        {
            this._next.addEventListener(MouseEvent.CLICK, this.__nextHanlder);
            this._pre.addEventListener(MouseEvent.CLICK, this.__preHanlder);
        }

        private function removeEvent():void
        {
            this._next.removeEventListener(MouseEvent.CLICK, this.__nextHanlder);
            this._pre.removeEventListener(MouseEvent.CLICK, this.__preHanlder);
        }

        private function __nextHanlder(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.present++;
            if (this._present > this._sum)
            {
                this.present = this.sum;
            }
            else
            {
                dispatchEvent(new Event(PAGE_CHANGE));
            };
            this.setBtnState();
        }

        private function setBtnState():void
        {
            if (this.present == 1)
            {
                this._pre.enable = false;
                this._pre.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
                this._pre.enable = true;
                this._pre.filters = null;
            };
            if (this.present == this.sum)
            {
                this._next.enable = false;
                this._next.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
                this._next.enable = true;
                this._next.filters = null;
            };
        }

        private function __preHanlder(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.present--;
            if (this._present < 1)
            {
                this.present = 1;
            }
            else
            {
                dispatchEvent(new Event(PAGE_CHANGE));
            };
            this.setBtnState();
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._bg.dispose();
            this._bg = null;
            this._bgI = null;
            this._next = null;
            this._pre = null;
            this._page = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

