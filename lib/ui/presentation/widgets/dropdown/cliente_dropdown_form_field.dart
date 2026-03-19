import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../../data/models/cliente.dart';

class ClienteDropdownFormField extends FormField<Cliente> {
  ClienteDropdownFormField({
    Key? key,
    Cliente? initialValue,
    required List<Cliente> listaClientes,
    ValueChanged<Cliente?>? onChanged,
    FormFieldValidator<Cliente>? validator,
  }) : super(
          key: key,
          initialValue: initialValue,
          validator: validator ??
              (value) {
                if (value == null) {
                  return 'Selecione um cliente';
                }
                return null;
              },
          builder: (FormFieldState<Cliente> field) {
            return DropdownSearch<Cliente>(
              asyncItems: (String filtro) async {
                return listaClientes
                    .where((c) =>
                        c.name!.toLowerCase().contains(filtro.toLowerCase()))
                    .toList();
              },
              selectedItem: field.value,
              itemAsString: (Cliente? cliente) => cliente?.name ?? 'Sem Nome',
              onChanged: (Cliente? clienteSelecionado) {
                field.didChange(clienteSelecionado);
                if (onChanged != null) {
                  onChanged(clienteSelecionado);
                }
              },
              dropdownBuilder: (context, clienteSelecionado) {
                return Text(
                  clienteSelecionado?.name ?? 'Selecione',
                  style: const TextStyle(fontSize: 16),
                );
              },
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: 'Cliente',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                  contentPadding:
                      const EdgeInsets.fromLTRB(0, 16, 0, 16), // ← Aqui
                  errorText: field.errorText,
                ),
              ),
              popupProps: const PopupProps.menu(
                showSearchBox: true,
              ),
            );
          },
        );
}