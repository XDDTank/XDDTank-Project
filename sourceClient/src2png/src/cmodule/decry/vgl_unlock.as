// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.vgl_unlock

package cmodule.decry
{
    public function vgl_unlock():void
    {
        if (((gvglbmd) && (gvglpixels)))
        {
            gstate.ds.position = gvglpixels;
            gvglbmd.setPixels(gvglbmd.rect, gstate.ds);
        };
    }

}//package cmodule.decry

