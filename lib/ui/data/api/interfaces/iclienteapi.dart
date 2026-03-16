
import '../../dto/cliente_dto.dart';
import '../../models/cliente.dart';

abstract class IClienteApi{
  Future<List<Cliente>> getList(int user_id, int cliente_id);
  Future<List<Cliente>> getListByFilter(ClienteDTO clienteDTO);
  Future<bool> addCliente(Cliente cliente, int user_id);
  Future<bool> updateCliente(Cliente cliente, int user_id);
}