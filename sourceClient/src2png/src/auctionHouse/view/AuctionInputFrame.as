// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.AuctionInputFrame

package auctionHouse.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;

    public class AuctionInputFrame extends BaseAlerFrame 
    {

        private var _alertInfo:AlertInfo;
        private var _SellText:FilterFrameText;
        private var _SellText1:FilterFrameText;
        private var _sellInputBg:Scale9CornerImage;

        public function AuctionInputFrame()
        {
            this.setView();
        }

        private function setView():void
        {
            this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBuyView.Auction"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"));
            this._alertInfo.moveEnable = false;
            info = this._alertInfo;
            this.escEnable = true;
            this._SellText = ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.SellLeftAlerText2");
            this._SellText.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.BrowseNumber");
            this._SellText1 = ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.SellLeftAlerText3");
            this._SellText1.text = LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.buction1");
            this._sellInputBg = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.SellLeftAlerInputBg1");
            addToContent(this._SellText);
            addToContent(this._SellText1);
            addToContent(this._sellInputBg);
        }

        override public function dispose():void
        {
            super.dispose();
        }


    }
}//package auctionHouse.view

