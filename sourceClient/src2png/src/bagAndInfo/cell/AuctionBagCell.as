// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.cell.AuctionBagCell

package bagAndInfo.cell
{
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.display.DisplayObject;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.SoundManager;

    public class AuctionBagCell extends LockBagCell 
    {

        private var _mouseOverEffBoolean:Boolean;

        public function AuctionBagCell(_arg_1:int, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true, _arg_4:DisplayObject=null, _arg_5:Boolean=true)
        {
            super(_arg_1, null, true, ComponentFactory.Instance.creatComponentByStylename("core.bagAndInfo.bagCellBgAsset"), true);
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                _arg_1.action = DragEffect.NONE;
                if (_arg_1.action == DragEffect.NONE)
                {
                    locked = false;
                };
                return;
            };
            _arg_1.action = DragEffect.NONE;
        }

        override public function dragStop(_arg_1:DragEffect):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.action == DragEffect.NONE) || (_arg_1.target == null)))
            {
                locked = false;
            };
        }


    }
}//package bagAndInfo.cell

