
<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="BiteBazaar.User.Cart" %>
<%@ Import Namespace="BiteBazaar" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script type="text/javascript">
        function updateCart(productId, quantity) {
            $.ajax({
                type: "POST",
                url: "Cart.aspx/UpdateCartQuantity",
                data: JSON.stringify({ productId: productId, quantity: quantity }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    // Handle the response if needed
                    location.reload(); // Reload the page to reflect the changes
                },
                failure: function (response) {
                    alert("Error updating cart.");
                }
            });
        }

        $(document).ready(function () {
            $(".quantity input").change(function () {
                var productId = $(this).data("productid");
                var quantity = $(this).val();
                var price = $(this).closest("tr").find(".lblPrice").text(); // Get the unit price
                var totalPrice = (parseFloat(price) * parseInt(quantity)).toFixed(2); // Calculate total price
                $(this).closest("tr").find(".lblTotalPrice").text(totalPrice); // Update total price label
                updateCart(productId, quantity);
            });

            $(".quantity .fa-plus").click(function () {
                var input = $(this).siblings("input");
                var currentQuantity = parseInt(input.val());
                var newQuantity = currentQuantity + 1;
                input.val(newQuantity).change(); // Trigger change event
            });

            $(".quantity .fa-minus").click(function () {
                var input = $(this).siblings("input");
                var currentQuantity = parseInt(input.val());
                var newQuantity = currentQuantity - 1;
                if (newQuantity >= 1) {
                    input.val(newQuantity).change(); // Trigger change event
                }
            });
        });
    </script>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="book_section layout_padding">
        <div class="container">
            <div class="heading_container">
                <div class="align-self-end">
                    <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>
                </div>
                <h2>Your Cart</h2>
            </div>
        </div>

        <div class="container">
            <asp:Repeater ID="rCartItem" runat="server" OnItemCommand="rCartItem_ItemCommand" 
                OnItemDataBound="rCartItem_ItemDataBound">
                <HeaderTemplate>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Image</th>
                                <th>Unit Price</th>
                                <th>Quantity</th>
                                <th>Total Price</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                     <tr>
                         <td>
                             <asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                         </td>
                         <td>
                             <img width="60" src="<%# Utils.GetImageUrl(Eval("ImageUrl")) %>" alt="" />
                         </td>
                         <td>TK <asp:Label ID="lblPrice" runat="server" Text='<%# Eval("Price") %>'></asp:Label>
                             <asp:HiddenField ID="hdnProductId" runat="server" Value='<%# Eval("ProductId") %>' />
                             <asp:HiddenField ID="hdnQuantity" runat="server" Value='<%# Eval("Qty") %>'/>
                             <asp:HiddenField ID="hdnPrdQuantity" runat="server" Value='<%# Eval("PrdQty") %>' />
                         </td>
                         <td>
                             <div class="product__details__option">
                                 <div class="quantity">
                                     <div class="pro-qty">
                                         <asp:TextBox ID="txtQuantity" runat="server" 
                                            TextMode="Number" Text='<%# Eval("Quantity") %>' 
                                            data-productid='<%# Eval("ProductId") %>' class="quantity-input">
                                         </asp:TextBox>
                                         <asp:RegularExpressionValidator ID="revQuantity" runat="server" 
                                             ErrorMessage="*" ForeColor="Red" Font-Size="Small" 
                                             ValidationExpression="[1-9]*" 
                                             ControlToValidate="txtQuantity" Display="Dynamic" 
                                             SetFocusOnError="true" EnableClientScript="true" ></asp:RegularExpressionValidator>
                                     </div>
                                 </div>
                             </div>
                         </td>
                         <td>
                             TK <asp:Label ID="lblTotalPrice" runat="server"></asp:Label>
                         </td>
                         <td>
                             <asp:LinkButton ID="lbDelete" runat="server" Text="Remove" CommandName="remove" 
                                 CommandArgument='<%# Eval("ProductId") %>' OnClientClick="return confirm('Do you want to remove this item from cart?');">
                                 <i class="fa fa-close"></i>
                             </asp:LinkButton>
                         </td>
                     </tr>
                </ItemTemplate>
                <FooterTemplate>
                    <tr>
                        <td colspan="3"></td>
                        <td class="pl-lg-5">
                            <b>Grand Total:-</b>
                        </td>
                        <td>TK <% Response.Write(Session["grandTotalPrice"]); %></td>
                        <td></td>
                    </tr>
                    <tr></tr>
                    <tr>
                        <td colspan="3" class="continue__btn">
                            <a href="Menu.aspx" class="btn btn-info">
                                <i class="fa fa-arrow-circle-left mr-2"></i>Continue Shopping
                            </a>
                        </td> 
                        <td colspan="3" style="text-align: center;">
                            <asp:LinkButton ID="lbCheckout" runat="server" CommandName="checkout" CssClass="btn btn-success">
                                Checkout<i class="fa fa-arrow-circle-right ml-2"></i>
                            </asp:LinkButton>
                        </td>
                    </tr>
                    </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </section>
</asp:Content>

