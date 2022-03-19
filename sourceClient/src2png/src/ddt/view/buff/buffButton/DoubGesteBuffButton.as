// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.buff.buffButton.DoubGesteBuffButton

package ddt.view.buff.buffButton
{
    import ddt.data.BuffInfo;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.ShopManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.LeavePageManager;
    import flash.events.MouseEvent;

    public class DoubGesteBuffButton extends BuffButton 
    {

        public function DoubGesteBuffButton()
        {
            super("asset.core.doubleGesteAsset");
            info = new BuffInfo(BuffInfo.DOUBLE_GESTE);
        }

        override protected function __onclick(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            if (Setting)
            {
                return;
            };
            super.__onclick(_arg_1);
            ShowTipManager.Instance.removeCurrentTip();
            if (PlayerManager.Instance.Self.Money >= ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue)
            {
                if ((!(checkBagLocked())))
                {
                    return;
                };
                if ((!((_info) && (_info.IsExist))))
                {
                    _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"), LanguageMgr.GetTranslation("tank.view.buff.doubleExp", ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue), "", LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                }
                else
                {
                    _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"), LanguageMgr.GetTranslation("tank.view.buff.addPrice", ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue), "", LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                };
                Setting = true;
                _local_2.addEventListener(FrameEvent.RESPONSE, __onBuyResponse);
            }
            else
            {
                LeavePageManager.showFillFrame();
            };
        }


    }
}//package ddt.view.buff.buffButton

